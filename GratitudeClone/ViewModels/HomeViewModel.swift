//
//  HomeViewModel.swift
//  GratitudeClone
//

import Foundation
import SwiftData

@Observable
final class HomeViewModel {
    var todaysPrompt: DailyPrompt?
    var todaysEntry: JournalEntry?
    var isShowingEditor = false

    private var modelContext: ModelContext?
    private var promptService: PromptService?

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Bonjour"
        case 12..<18:
            return "Bon après-midi"
        default:
            return "Bonsoir"
        }
    }

    var hasWrittenToday: Bool {
        todaysEntry != nil
    }

    func configure(modelContext: ModelContext, promptService: PromptService) {
        self.modelContext = modelContext
        self.promptService = promptService
        loadTodaysData()
    }

    func loadTodaysData() {
        todaysPrompt = promptService?.getTodaysPrompt()
        todaysEntry = fetchTodaysEntry()
    }

    private func fetchTodaysEntry() -> JournalEntry? {
        guard let modelContext else { return nil }

        let startOfDay = Date().startOfDay
        let endOfDay = Date().endOfDay

        let predicate = #Predicate<JournalEntry> { entry in
            entry.createdAt >= startOfDay && entry.createdAt <= endOfDay
        }

        let descriptor = FetchDescriptor<JournalEntry>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        return try? modelContext.fetch(descriptor).first
    }

    func createOrEditEntry() {
        if todaysEntry == nil, let modelContext {
            let newEntry = JournalEntry()
            newEntry.prompt = todaysPrompt
            modelContext.insert(newEntry)

            if let prompt = todaysPrompt {
                promptService?.markPromptAsUsed(prompt)
            }

            todaysEntry = newEntry
        }
        isShowingEditor = true
    }

    func saveEntry(content: String, mood: Mood?) {
        guard let entry = todaysEntry else { return }

        entry.content = content
        entry.mood = mood
        entry.updatedAt = Date()

        try? modelContext?.save()
    }

    func refreshData() {
        loadTodaysData()
    }

    func changePrompt() {
        guard let newPrompt = promptService?.getRandomPrompt(excluding: todaysPrompt) else { return }
        todaysPrompt = newPrompt
    }
}
