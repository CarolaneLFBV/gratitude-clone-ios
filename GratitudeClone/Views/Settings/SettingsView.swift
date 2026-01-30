//
//  SettingsView.swift
//  GratitudeClone
//

import SwiftUI

struct SettingsView: View {
    @Environment(UserDefaultsService.self) private var userDefaultsService
    @Environment(NotificationService.self) private var notificationService
    @State private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            List {
                NotificationsSection(viewModel: viewModel)
                AppearanceSection(userDefaultsService: userDefaultsService)
                AboutSection()
            }
            .navigationTitle("Réglages")
            .onAppear {
                viewModel.configure(
                    userDefaultsService: userDefaultsService,
                    notificationService: notificationService
                )
            }
        }
    }
}

private struct NotificationsSection: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        Section {
            if viewModel.isNotificationAuthorized {
                Toggle("Rappel quotidien", isOn: $viewModel.isNotificationEnabled)

                if viewModel.isNotificationEnabled {
                    DatePicker(
                        "Heure du rappel",
                        selection: $viewModel.notificationTime,
                        displayedComponents: .hourAndMinute
                    )
                }
            } else {
                Button {
                    Task {
                        await viewModel.requestNotificationPermission()
                    }
                } label: {
                    HStack {
                        Label("Activer les notifications", systemImage: "bell.badge")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        } header: {
            Text("Notifications")
        } footer: {
            Text("Recevez un rappel quotidien pour prendre un moment de réflexion.")
        }
    }
}

private struct AppearanceSection: View {
    @Bindable var userDefaultsService: UserDefaultsService

    var body: some View {
        Section("Apparence") {
            Picker("Thème", selection: $userDefaultsService.selectedTheme) {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    Text(theme.label).tag(theme)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

private struct AboutSection: View {
    var body: some View {
        Section("À propos") {
            HStack {
                Text("Version")
                Spacer()
                Text(appVersion)
                    .foregroundStyle(.secondary)
            }

            Link(destination: URL(string: "https://example.com/privacy")!) {
                HStack {
                    Text("Politique de confidentialité")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}

#Preview {
    SettingsView()
        .environment(UserDefaultsService())
        .environment(NotificationService())
}
