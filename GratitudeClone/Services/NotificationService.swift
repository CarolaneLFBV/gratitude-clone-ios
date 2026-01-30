//
//  NotificationService.swift
//  GratitudeClone
//

import Foundation
import UserNotifications

@Observable
final class NotificationService {
    private(set) var isAuthorized = false

    private let notificationCenter = UNUserNotificationCenter.current()
    private let notificationIdentifier = "daily-journal-reminder"

    init() {
        Task {
            await checkAuthorizationStatus()
        }
    }

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
            await MainActor.run {
                isAuthorized = granted
            }
            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }

    func checkAuthorizationStatus() async {
        let settings = await notificationCenter.notificationSettings()
        await MainActor.run {
            isAuthorized = settings.authorizationStatus == .authorized
        }
    }

    func scheduleDailyReminder(hour: Int, minute: Int) async {
        await cancelAllNotifications()

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = "Moment de réflexion"
        content.body = "Prenez quelques minutes pour écrire dans votre journal."
        content.sound = .default
        content.badge = 1

        let request = UNNotificationRequest(
            identifier: notificationIdentifier,
            content: content,
            trigger: trigger
        )

        do {
            try await notificationCenter.add(request)
        } catch {
            print("Failed to schedule notification: \(error)")
        }
    }

    func cancelAllNotifications() async {
        notificationCenter.removeAllPendingNotificationRequests()
        await clearBadge()
    }

    func clearBadge() async {
        do {
            try await notificationCenter.setBadgeCount(0)
        } catch {
            print("Failed to clear badge: \(error)")
        }
    }
}
