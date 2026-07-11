import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:track_flowers_app/app.dart';
import 'package:track_flowers_app/config/api/api_key.dart';
import 'package:track_flowers_app/config/database/cache_helper.dart';
import 'package:track_flowers_app/config/fcm/fcm_service.dart';
import 'package:track_flowers_app/config/helper/bloc_observer.dart';
import 'package:track_flowers_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/firebase_options.dart';
import 'config/dependency_injection/di.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:track_flowers_app/config/env/google_maps_initializer.dart';

//flutter pub run build_runner build --delete-conflicting-outputs
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // Provide the Google Maps key (from .env) to the native iOS SDK.
  await GoogleMapsInitializer.configureIfNeeded();

  configureDependencies();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppSharedPreferences.initialSharedPreference();
  await EasyLocalization.ensureInitialized();
  // await AppSharedPreferences.clear();
  // await AppSharedPreferences.setString(
  //   key: APIkeys.accessToken,
  //   value:
  //       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2YTNkY2I3Nzk5MjYxMmFlNTk5YjVmZTgiLCJpYXQiOjE3ODI0MzQ2ODB9.U6HTRcwUSXvvkw-asVZj2EQRiszXyZ5zILGIcbHjCdU",
  // );
  Bloc.observer = MyBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await FCMService().initialize();
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };

  runApp(
    EasyLocalization(
      startLocale: const Locale('en', 'US'),
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
      path: AppConstants.translationPath,
      fallbackLocale: const Locale('ar', 'EG'),
      child: const MyApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // Temporarily disable Firebase for testing
    // if (!kIsWeb && defaultTargetPlatform != TargetPlatform.windows) {
    //   await FirebaseNotifications.initializeFirebase(role: null);
    // }
  });
}
