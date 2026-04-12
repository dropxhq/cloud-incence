import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    private let burnCompleteId = "cloud-incense.burn-complete"
    private init() {}

    func scheduleBurnComplete() {
        let duration = BurnSession.burnDuration
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { [weak self] granted, _ in
            guard granted, let self else { return }
            let content = UNMutableNotificationContent()
            content.title = "祈祷完成"
            content.body = "您的心愿已达天听 🙏"
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: duration,
                repeats: false
            )
            let request = UNNotificationRequest(
                identifier: self.burnCompleteId,
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }

    func cancelAll() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [burnCompleteId])
    }
}
