import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer';
import 'package:track_flowers_app/core/values/app_colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:track_flowers_app/config/fcm/user_entity.dart';

bool isFCMInitialized = false;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

/// A parsed order-status push (e.g. the customer confirming delivery).
class OrderStatusPush {
  final String orderId;
  final String status;

  const OrderStatusPush({required this.orderId, required this.status});

  static OrderStatusPush? fromData(Map<String, dynamic> data) {
    if (data['type'] != 'order_status') return null;
    final orderId = (data['orderId'] ?? '').toString();
    final status = (data['status'] ?? '').toString();
    if (orderId.isEmpty || status.isEmpty) return null;
    return OrderStatusPush(orderId: orderId, status: status);
  }
}

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Broadcasts order-status pushes so interested cubits can react live
  /// (e.g. move an order to "delivered" when the customer confirms receipt).
  final StreamController<OrderStatusPush> _orderStatusController =
      StreamController<OrderStatusPush>.broadcast();
  Stream<OrderStatusPush> get orderStatusStream =>
      _orderStatusController.stream;

  /// Initialize FCM and set up all notification handlers.
  ///
  /// [onToken] is invoked with the current token and on every refresh so the
  /// caller can persist it (e.g. register the driver under `users/{driverId}`).
  Future<void> initialize({void Function(String token)? onToken}) async {
    if (isFCMInitialized) return;
    // Request notification permissions (iOS and Android 13+)
    NotificationSettings settings = await _firebaseMessaging
        .requestPermission();

    log('User granted permission: ${settings.authorizationStatus}');

    // Initialize local notifications for foreground handling
    await _initializeLocalNotifications();

    // Get and store FCM token (unique device identifier)
    _fcmToken = await _firebaseMessaging.getToken();
    log('FCM Token: $_fcmToken');
    // Register the token (e.g. persist it under users/{driverId}).
    if (_fcmToken != null) onToken?.call(_fcmToken!);

    // Listen for token refresh (happens when app reinstalled, data cleared, etc.)
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      log('FCM Token refreshed: $newToken');
      onToken?.call(newToken);
    });

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Handle notification when app is in FOREGROUND
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification tap when app is in BACKGROUND (not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from a TERMINATED state by tapping notification
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    isFCMInitialized = true;
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    // Android notification icon (place in android/app/src/main/res/drawable/)
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS notification settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize with callback for when notification is tapped
    await _localNotifications.initialize(settings: initSettings);

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // Must match AndroidManifest
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.high, // Shows as heads-up notification
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Handle messages when app is in FOREGROUND
  void _handleForegroundMessage(RemoteMessage message) {
    showLocalNotification(message);
    _emitOrderStatus(message);
  }

  /// Parse an order-status data payload and broadcast it to listeners.
  void _emitOrderStatus(RemoteMessage message) {
    final push = OrderStatusPush.fromData(message.data);
    if (push != null && !_orderStatusController.isClosed) {
      _orderStatusController.add(push);
    }
  }

  /// Display local notification
  Future<void> showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications',
          importance: Importance.max,
          priority: Priority.high,
          color: AppColors.primerColor,
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // Prefer localization keys from the data payload so the notification shows
    // in THIS device's language, regardless of the sender's locale.
    final data = message.data;
    final titleKey = (data['titleKey'] ?? '').toString();
    final bodyKey = (data['bodyKey'] ?? '').toString();
    final namedArgs = {'orderNumber': (data['orderNumber'] ?? '').toString()};
    final title = titleKey.isNotEmpty
        ? titleKey.tr(namedArgs: namedArgs)
        : notification?.title;
    final body = bodyKey.isNotEmpty
        ? bodyKey.tr(namedArgs: namedArgs)
        : notification?.body;

    if (title == null && body == null) return;

    await _localNotifications.show(
      id: (notification?.hashCode ?? DateTime.now().millisecondsSinceEpoch),
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: message.data.toString(), // Pass data for tap handling
    );
  }

  /// Handle notification tap (from background or terminated state)
  void _handleNotificationTap(RemoteMessage message) {
    log('Notification tapped!');
    log('Message data: ${message.data}');
    _emitOrderStatus(message);

    if (message.data['screen'] != null) {}
  }

  /// Send a push notification directly from the client to multiple FCM tokens.
  /// NOTE: This uses the modern FCM HTTP v1 API.
  /// Since the Legacy API is shutting down, you MUST use a Service Account JSON.
  /// ⚠️ IMPORTANT: For production, this logic belongs on your backend!
  Future<void> sendNotification({
    required List<FCMTokenEntity> targetFcmTokens,
    required String title,
    required String body,
    Map<String, String> data = const {},
  }) async {
    try {
      // 1. Go to Firebase Console -> Project Settings -> Service Accounts
      // 2. Click "Generate new private key"
      // 3. Paste the entire content of that downloaded JSON file below:
      final String projectId = dotenv.env['FCM_PROJECT_ID'] ?? '';
      final String privateKeyId = dotenv.env['FCM_PRIVATE_KEY_ID'] ?? '';
      final String privateKey = (dotenv.env['FCM_PRIVATE_KEY'] ?? '')
          .replaceAll('\\n', '\n');
      final String clientEmail = dotenv.env['FCM_CLIENT_EMAIL'] ?? '';
      final String clientId = dotenv.env['FCM_CLIENT_ID'] ?? '';
      final String clientX509CertUrl =
          dotenv.env['FCM_CLIENT_X509_CERT_URL'] ?? '';

      final String serviceAccountJsonString = jsonEncode({
        "type": "service_account",
        "project_id": projectId,
        "private_key_id": privateKeyId,
        "private_key": privateKey,
        "client_email": clientEmail,
        "client_id": clientId,
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": clientX509CertUrl,
        "universe_domain": "googleapis.com",
      });

      if (serviceAccountJsonString.contains('REPLACE_ME')) {
        log(
          'Error: You must paste your Service Account JSON into fcm_service.dart first.',
        );
        return;
      }

      // 4. Authenticate using the Service Account JSON
      final accountCredentials = ServiceAccountCredentials.fromJson(
        serviceAccountJsonString,
      );
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final client = await clientViaServiceAccount(accountCredentials, scopes);

      final url =
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

      for (var tokenData in targetFcmTokens) {
        final token = tokenData.token;

        if (token.isEmpty) continue;

        // 5. Build the modern HTTP v1 message payload
        final Map<String, dynamic> messageData = {
          'message': {
            'token': token,
            'notification': {'title': title, 'body': body},
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'message': 'custom data',
              ...data,
            },
          },
        };

        // 6. Send the notification
        final response = await client.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(messageData),
        );

        if (response.statusCode == 200) {
          log('Notification sent successfully to $token');
        } else {
          log('Failed to send notification to $token: ${response.body}');
        }
      }

      client.close();
    } catch (e) {
      log('Error sending notification: $e');
    }
  }
}
