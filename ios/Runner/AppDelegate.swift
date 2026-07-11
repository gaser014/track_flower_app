import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // The Google Maps SDK key is provided from Dart, which reads it from the
    // `.env` file (`google_map_key`). This keeps a single source of truth for
    // the key across platforms. The map is only created on demand, well after
    // this handler runs, so the key is always set before the first map view.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "GoogleMapsKeyChannel") {
      let channel = FlutterMethodChannel(
        name: "app/google_maps",
        binaryMessenger: registrar.messenger()
      )
      channel.setMethodCallHandler { call, result in
        if call.method == "setApiKey", let key = call.arguments as? String, !key.isEmpty {
          GMSServices.provideAPIKey(key)
          result(true)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }
}
