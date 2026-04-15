import UIKit
import UserNotifications

/// Minimal AppDelegate — handles notification presentation while the app is
/// in the foreground and logs deep-link userInfo for future handling.
final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        // RevenueCat.configure(...) would go here behind a build flag.
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        [.banner, .sound, .badge]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        // Parse `deepLink` userInfo and post a Notification that the root
        // coordinator can observe when deep-link routing lands. Deferred.
        if let link = response.notification.request.content.userInfo["deepLink"] as? String {
            print("Deep link: \(link)")
        }
    }
}
