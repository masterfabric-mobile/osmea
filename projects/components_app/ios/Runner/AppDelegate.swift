import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Read the API key from the Info.plist, which is populated by the xcconfig file.
    // Make it optional so the app can run without it (Google Maps features won't work)
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String, 
       !apiKey.isEmpty, 
       apiKey != "YOUR_API_KEY_HERE",
       apiKey != "$(API_KEY)" {
      GMSServices.provideAPIKey(apiKey)
    } else {
      print("Warning: API_KEY not found or is empty. Google Maps features will not work.")
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
