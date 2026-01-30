//
//  JournalEntryRow.swift
//  GratitudeClone
//

import SwiftUI

struct JournalEntryRow: View {
    let entry: JournalEntry

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack {
                Text(dayNumber)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(dayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 44)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    if let mood = entry.mood {
                        Text(mood.emoji)
                    }

                    if let prompt = entry.prompt {
                        Label(prompt.category.label, systemImage: prompt.category.icon)
                            .font(.caption)
                            .foregroundStyle(prompt.category.color)
                    }

                    Spacer()

                    Text(entry.createdAt.timeFormatted)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                if !entry.content.isEmpty {
                    Text(entry.content)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                }

                if let promptText = entry.prompt?.text {
                    Text(promptText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .italic()
                }
            }
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }

    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: entry.createdAt)
    }

    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale.current
        return formatter.string(from: entry.createdAt).uppercased()
    }

    private var accessibilityDescription: String {
        var description = entry.createdAt.relativeFormatted

        if let mood = entry.mood {
            description += ", humeur: \(mood.label)"
        }

        if !entry.content.isEmpty {
            description += ", \(entry.content)"
        }

        return description
    }
}

#Preview {
    List {
        JournalEntryRow(
            entry: {
                let entry = JournalEntry(
                    content: "Aujourd'hui j'ai passé un bon moment avec ma famille...",
                    mood: .happy
                )
                return entry
            }()
        )
    }
}
