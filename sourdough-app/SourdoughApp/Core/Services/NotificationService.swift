import Foundation
import UserNotifications

/// Wraps `UNUserNotificationCenter` for local reminders — feeding alerts
/// and bake timers. Remote push (APNs / FCM) is out of scope for this
/// scaffold.
protocol NotificationService: AnyObject {
    func requestAuthorization() async -> Bool
    func scheduleFeedingReminder(for starter: Starter) async
    func scheduleBakeStepTimer(sessionId: UUID, stepId: UUID, title: String, body: String, fireAt: Date) async
    func cancelFeedingReminder(starterId: UUID)
    func cancelAll()
}

final class LocalNotificationService: NotificationService {

    private let center = UNUserNotificationCenter.current()

    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    func scheduleFeedingReminder(for starter: Starter) async {
        guard let next = FeedingScheduler.nextFeeding(for: starter) else { return }
        let leadHours = MockUser.sample.settings.feedingReminderLeadTimeHours
        let fireAt = next.addingTimeInterval(-Double(leadHours * 3600))
        guard fireAt > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "\(starter.name) needs feeding 🍞"
        content.body = "Peak activity in ~\(leadHours) hours. Feed now for best results."
        content.sound = .default
        content.userInfo = ["deepLink": "sourdough://starters/\(starter.id)"]

        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireAt)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let req = UNNotificationRequest(identifier: "feeding-\(starter.id)", content: content, trigger: trigger)
        try? await center.add(req)
    }

    func scheduleBakeStepTimer(sessionId: UUID, stepId: UUID, title: String, body: String, fireAt: Date) async {
        guard fireAt > Date() else { return }
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = ["deepLink": "sourdough://bake/\(sessionId)"]

        let interval = fireAt.timeIntervalSinceNow
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let req = UNNotificationRequest(identifier: "bake-\(sessionId)-\(stepId)", content: content, trigger: trigger)
        try? await center.add(req)
    }

    func cancelFeedingReminder(starterId: UUID) {
        center.removePendingNotificationRequests(withIdentifiers: ["feeding-\(starterId)"])
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }
}

/// Mock implementation that logs to stdout — useful in previews / tests.
final class MockNotificationService: NotificationService {
    func requestAuthorization() async -> Bool { true }
    func scheduleFeedingReminder(for starter: Starter) async {
        print("[MockNotif] schedule feeding for \(starter.name)")
    }
    func scheduleBakeStepTimer(sessionId: UUID, stepId: UUID, title: String, body: String, fireAt: Date) async {
        print("[MockNotif] schedule bake step \(title) at \(fireAt)")
    }
    func cancelFeedingReminder(starterId: UUID) { }
    func cancelAll() { }
}
