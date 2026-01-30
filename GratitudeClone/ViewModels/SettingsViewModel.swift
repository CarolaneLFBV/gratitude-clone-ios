//
//  SettingsViewModel.swift
//  GratitudeClone
//

import Foundation

@Observable
final class SettingsViewModel {
    private var userDefaultsService: UserDefaultsService?
    private var notificationService: NotificationService?

    var isNotificationEnabled: Bool = false {
        didSet {
            userDefaultsService?.isNotificationEnabled = isNotificationEnabled
            Task {
                await updateNotifications()
            }
        }
    }

    var notificationTime: Date = Date() {
        didSet {
            userDefaultsService?.notificationTime = notificationTime
            Task {
                await updateNotifications()
            }
        }
    }

    var selectedTheme: AppTheme = .system {
        didSet {
            userDefaultsService?.selectedTheme = selectedTheme
        }
    }

    var isNotificationAuthorized: Bool {
        notificationService?.isAuthorized ?? false
    }

    func configure(userDefaultsService: UserDefaultsService, notificationService: NotificationService) {
        self.userDefaultsService = userDefaultsService
        self.notificationService = notificationService

        isNotificationEnabled = userDefaultsService.isNotificationEnabled
        notificationTime = userDefaultsService.notificationTime
        selectedTheme = userDefaultsService.selectedTheme
    }

    func requestNotificationPermission() async {
        guard let notificationService else { return }

        let granted = await notificationService.requestAuthorization()
        if granted {
            isNotificationEnabled = true
        }
    }

    private func updateNotifications() async {
        guard let notificationService, let userDefaultsService else { return }

        if isNotificationEnabled && notificationService.isAuthorized {
            await notificationService.scheduleDailyReminder(
                hour: userDefaultsService.notificationHour,
                minute: userDefaultsService.notificationMinute
            )
        } else {
            await notificationService.cancelAllNotifications()
        }
    }
}
