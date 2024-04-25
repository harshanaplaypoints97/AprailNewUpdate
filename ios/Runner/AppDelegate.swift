import UIKit
import Flutter
import FacebookCore
import FBAudienceNetwork



@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//      self.window.makeSecure()
      AppEvents.activateApp()
      GeneratedPluginRegistrant.register(with: self)
      Settings.setAdvertiserTrackingEnabled(true)
      FBAdSettings.setAdvertiserTrackingEnabled(true)
      UNUserNotificationCenter.current().delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      
  }
}

func applicationDidBecomeActive(_ application: UIApplication) {
  AppEvents.activateApp()
}

extension UIWindow {
  func makeSecure() {
      let field = UITextField()
      field.isSecureTextEntry = true
      self.addSubview(field)
      field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
      field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      self.layer.superlayer?.addSublayer(field.layer)
      field.layer.sublayers?.first?.addSublayer(self.layer)
    }
  }

