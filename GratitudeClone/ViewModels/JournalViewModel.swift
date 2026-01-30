//
//  JournalViewModel.swift
//  GratitudeClone
//

import Foundation
import SwiftData

@Observable
final class JournalViewModel {
    var entries: [JournalEntry] = []
    var searchText = ""
    var selectedCategory: PromptCategory?
    var selectedMood: Mood?

    private var modelContext: ModelContext?

    var filteredEntries: [JournalEntry] {
        var result = entries

        if !searchText.isEmpty {
            result = result.filter { entry in
                entry.content.localizedCaseInsensitiveContains(searchText) ||
                (entry.prompt?.text.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }

        if let selectedCategory {
            result = result.filter { $0.prompt?.category == selectedCategory }
        }

        if let selectedMood {
            result = result.filter { $0.mood == selectedMood }
        }

        return result
    }

    var groupedEntries: [(String, [JournalEntry])] {
        let grouped = Dictionary(grouping: filteredEntries) { entry in
            entry.createdAt.monthYearFormatted
        }

        return grouped
            .sorted { $0.value.first?.createdAt ?? Date() > $1.value.first?.createdAt ?? Date() }
            .map { ($0.key, $0.value.sorted { $0.createdAt > $1.createdAt }) }
    }

    var totalEntries: Int {
        entries.count
    }

    var currentStreak: Int {
        calculateStreak()
    }

    var hasActiveFilters: Bool {
        !searchText.isEmpty || selectedCategory != nil || selectedMood != nil
    }

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchEntries()
    }

    func fetchEntries() {
        guard let modelContext else { return }

        let descriptor = FetchDescriptor<JournalEntry>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        entries = (try? modelContext.fetch(descriptor)) ?? []
    }

    func deleteEntry(_ entry: JournalEntry) {
        modelContext?.delete(entry)
        try? modelContext?.save()
        fetchEntries()
    }

    func deleteEntries(at offsets: IndexSet, in section: [JournalEntry]) {
        for index in offsets {
            let entry = section[index]
            modelContext?.delete(entry)
        }
        try? modelContext?.save()
        fetchEntries()
    }

    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        selectedMood = nil
    }

    private func calculateStreak() -> Int {
        guard !entries.isEmpty else { return 0 }

        let sortedEntries = entries.sorted { $0.createdAt > $1.createdAt }
        var streak = 0
        var currentDate = Date().startOfDay

        if !sortedEntries.first!.createdAt.isSameDay(as: currentDate) {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            if !sortedEntries.first!.createdAt.isSameDay(as: yesterday) {
                return 0
            }
            currentDate = yesterday
        }

        for entry in sortedEntries {
            if entry.createdAt.isSameDay(as: currentDate) {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            } else if entry.createdAt < currentDate {
                break
            }
        }

        return streak
    }
}
