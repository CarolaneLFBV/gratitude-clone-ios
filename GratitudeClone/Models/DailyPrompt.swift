//
//  DailyPrompt.swift
//  GratitudeClone
//

import Foundation
import SwiftData

@Model
final class DailyPrompt {
    var id: UUID
    var text: String
    var categoryRaw: String
    var scheduledDate: Date?
    var lastUsedDate: Date?

    @Relationship(deleteRule: .nullify, inverse: \JournalEntry.prompt)
    var entries: [JournalEntry]?

    var category: PromptCategory {
        get { PromptCategory(rawValue: categoryRaw) ?? .reflection }
        set { categoryRaw = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        text: String,
        category: PromptCategory,
        scheduledDate: Date? = nil,
        lastUsedDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.categoryRaw = category.rawValue
        self.scheduledDate = scheduledDate
        self.lastUsedDate = lastUsedDate
    }
}
