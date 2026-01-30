//
//  GratitudeCloneApp.swift
//  GratitudeClone
//

import SwiftUI
import SwiftData

@main
struct GratitudeCloneApp: App {
    @State private var userDefaultsService = UserDefaultsService()
    @State private var notificationService = NotificationService()
    @State private var promptService = PromptService()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            JournalEntry.self,
            DailyPrompt.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(userDefaultsService.selectedTheme.colorScheme)
                .onAppear {
                    promptService.configure(with: sharedModelContainer.mainContext)
                    Task {
                        await notificationService.clearBadge()
                    }
                }
        }
        .modelContainer(sharedModelContainer)
        .environment(userDefaultsService)
        .environment(notificationService)
        .environment(promptService)
    }
}
