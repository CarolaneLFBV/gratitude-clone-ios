//
//  PromptService.swift
//  GratitudeClone
//

import Foundation
import SwiftData

@Observable
final class PromptService {
    private var modelContext: ModelContext?
    private var cachedPrompts: [PromptData] = []

    func configure(with modelContext: ModelContext) {
        self.modelContext = modelContext
        loadPromptsFromJSON()
        syncPromptsToSwiftData()
    }

    private func loadPromptsFromJSON() {
        guard let url = Bundle.main.url(forResource: "prompts", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let promptsFile = try? JSONDecoder().decode(PromptsFile.self, from: data) else {
            print("Failed to load prompts.json")
            return
        }
        cachedPrompts = promptsFile.prompts
    }

    private func syncPromptsToSwiftData() {
        guard let modelContext else { return }

        let existingPrompts = fetchAllPrompts()
        let existingTexts = Set(existingPrompts.map { $0.text })

        for promptData in cachedPrompts {
            if !existingTexts.contains(promptData.text) {
                let newPrompt = DailyPrompt(text: promptData.text, category: promptData.category)
                modelContext.insert(newPrompt)
            }
        }

        try? modelContext.save()
    }

    func getTodaysPrompt() -> DailyPrompt? {
        let allPrompts = fetchAllPrompts()
        guard !allPrompts.isEmpty else { return nil }

        let recentlyUsedPrompts = getRecentlyUsedPromptIds()
        let availablePrompts = allPrompts.filter { prompt in
            !recentlyUsedPrompts.contains(prompt.id)
        }

        let promptsToChooseFrom = availablePrompts.isEmpty ? allPrompts : availablePrompts

        let dayOfYear = Date().dayOfYear
        let index = dayOfYear % promptsToChooseFrom.count
        return promptsToChooseFrom[index]
    }

    private func fetchAllPrompts() -> [DailyPrompt] {
        guard let modelContext else { return [] }

        let descriptor = FetchDescriptor<DailyPrompt>(sortBy: [SortDescriptor(\.text)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    private func getRecentlyUsedPromptIds() -> Set<UUID> {
        guard let modelContext else { return [] }

        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let predicate = #Predicate<JournalEntry> { entry in
            entry.createdAt >= sevenDaysAgo
        }

        let descriptor = FetchDescriptor<JournalEntry>(predicate: predicate)
        let recentEntries = (try? modelContext.fetch(descriptor)) ?? []

        return Set(recentEntries.compactMap { $0.prompt?.id })
    }

    func markPromptAsUsed(_ prompt: DailyPrompt) {
        prompt.lastUsedDate = Date()
        try? modelContext?.save()
    }

    func getRandomPrompt(excluding currentPrompt: DailyPrompt?) -> DailyPrompt? {
        let allPrompts = fetchAllPrompts()
        guard allPrompts.count > 1 else { return allPrompts.first }

        let availablePrompts = allPrompts.filter { $0.id != currentPrompt?.id }
        return availablePrompts.randomElement()
    }
}
