import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyC16rxHK2CGpngeZK_rF8gfVi42sAu9OsA")
//    AIzaSyC16rxHK2CGpngeZK_rF8gfVi42sAu9OsA - maps
//    AIzaSyBiJlz7cl-97Bx_EBRuicVeFnKjDiNBkvY - firebase
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
