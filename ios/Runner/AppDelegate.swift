import UIKit
import Flutter
import GoogleMaps  // ← Dòng quan trọng này

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Khởi tạo Google Maps với API Key
    GMSServices.provideAPIKey("AIzaSyAp1RCvhPuqKWdQlOZfYuGWQ3dAY8vr0yk")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}