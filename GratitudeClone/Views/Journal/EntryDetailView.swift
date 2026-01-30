//
//  EntryDetailView.swift
//  GratitudeClone
//

import SwiftUI
import SwiftData

struct EntryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var entry: JournalEntry

    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeaderSection(entry: entry)

                if let prompt = entry.prompt {
                    PromptSection(prompt: prompt)
                }

                if let mood = entry.mood {
                    MoodSection(mood: mood)
                }

                ContentSection(content: entry.content)

                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle(entry.createdAt.relativeFormatted)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isEditing = true
                } label: {
                    Image(systemName: "pencil")
                }
                .accessibilityLabel("Modifier l'entrée")
            }
        }
        .sheet(isPresented: $isEditing) {
            EntryEditorView(
                entry: entry,
                prompt: entry.prompt
            ) { content, mood in
                entry.content = content
                entry.mood = mood
                entry.updatedAt = Date()
                try? modelContext.save()
            }
        }
    }
}

private struct HeaderSection: View {
    let entry: JournalEntry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.createdAt.formatted(date: .complete, time: .omitted))
                    .font(.headline)

                Text("Modifié à \(entry.updatedAt.timeFormatted)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let mood = entry.mood {
                Text(mood.emoji)
                    .font(.largeTitle)
            }
        }
    }
}

private struct PromptSection: View {
    let prompt: DailyPrompt

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Prompt", systemImage: "sparkles")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(prompt.text)
                .font(.body)
                .italic()
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(prompt.category.color.opacity(0.1))
        )
    }
}

private struct MoodSection: View {
    let mood: Mood

    var body: some View {
        HStack(spacing: 8) {
            Text(mood.emoji)
                .font(.title2)

            Text(mood.label)
                .font(.subheadline)
                .foregroundStyle(mood.color)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(mood.color.opacity(0.15))
        )
    }
}

private struct ContentSection: View {
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Réflexion", systemImage: "text.alignleft")
                .font(.caption)
                .foregroundStyle(.secondary)

            if content.isEmpty {
                Text("Aucun contenu")
                    .font(.body)
                    .foregroundStyle(.tertiary)
                    .italic()
            } else {
                Text(content)
                    .font(.body)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EntryDetailView(
            entry: JournalEntry(
                content: "Aujourd'hui j'ai passé un bon moment avec ma famille. Nous avons partagé un repas ensemble et discuté de nos projets pour l'été.",
                mood: .happy
            )
        )
    }
    .modelContainer(for: JournalEntry.self, inMemory: true)
}
