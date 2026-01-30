//
//  UserDefaultsService.swift
//  GratitudeClone
//

import SwiftUI

@Observable
final class UserDefaultsService {
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let isNotificationEnabled = "isNotificationEnabled"
        static let notificationHour = "notificationHour"
        static let notificationMinute = "notificationMinute"
        static let selectedTheme = "selectedTheme"
    }

    // Propriétés stockées pour que @Observable puisse les observer
    var isNotificationEnabled: Bool {
        didSet { defaults.set(isNotificationEnabled, forKey: Keys.isNotificationEnabled) }
    }

    var notificationHour: Int {
        didSet {
            defaults.set(notificationHour, forKey: Keys.notificationHour)
            defaults.set(true, forKey: "notificationHourSet")
        }
    }

    var notificationMinute: Int {
        didSet { defaults.set(notificationMinute, forKey: Keys.notificationMinute) }
    }

    var selectedTheme: AppTheme {
        didSet { defaults.set(selectedTheme.rawValue, forKey: Keys.selectedTheme) }
    }

    var notificationTime: Date {
        get {
            var components = DateComponents()
            components.hour = notificationHour
            components.minute = notificationMinute
            return Calendar.current.date(from: components) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            notificationHour = components.hour ?? 20
            notificationMinute = components.minute ?? 0
        }
    }

    init() {
        // Charger les valeurs depuis UserDefaults au démarrage
        self.isNotificationEnabled = defaults.bool(forKey: Keys.isNotificationEnabled)

        let hour = defaults.integer(forKey: Keys.notificationHour)
        self.notificationHour = hour == 0 && !defaults.bool(forKey: "notificationHourSet") ? 20 : hour

        self.notificationMinute = defaults.integer(forKey: Keys.notificationMinute)

        if let rawValue = defaults.string(forKey: Keys.selectedTheme),
           let theme = AppTheme(rawValue: rawValue) {
            self.selectedTheme = theme
        } else {
            self.selectedTheme = .system
        }
    }
}

enum AppTheme: String, CaseIterable {
    case system
    case light
    case dark

    var label: String {
        switch self {
        case .system: return "Système"
        case .light: return "Clair"
        case .dark: return "Sombre"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
