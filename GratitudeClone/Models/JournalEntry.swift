//
//  JournalEntry.swift
//  GratitudeClone
//

import Foundation
import SwiftData

@Model
final class JournalEntry {
    var id: UUID
    var content: String
    var createdAt: Date
    var updatedAt: Date
    var moodRaw: String?

    var prompt: DailyPrompt?

    var mood: Mood? {
        get {
            guard let moodRaw else { return nil }
            return Mood(rawValue: moodRaw)
        }
        set { moodRaw = newValue?.rawValue }
    }

    init(
        id: UUID = UUID(),
        content: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        mood: Mood? = nil,
        prompt: DailyPrompt? = nil
    ) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.moodRaw = mood?.rawValue
        self.prompt = prompt
    }
}
