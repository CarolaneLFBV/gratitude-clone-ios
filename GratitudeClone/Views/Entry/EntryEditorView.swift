//
//  EntryEditorView.swift
//  GratitudeClone
//

import SwiftUI

struct EntryEditorView: View {
    @Environment(\.dismiss) private var dismiss

    let entry: JournalEntry
    let prompt: DailyPrompt?
    let onSave: (String, Mood?) -> Void

    @State private var content: String
    @State private var selectedMood: Mood?
    @FocusState private var isTextEditorFocused: Bool

    init(entry: JournalEntry, prompt: DailyPrompt?, onSave: @escaping (String, Mood?) -> Void) {
        self.entry = entry
        self.prompt = prompt
        self.onSave = onSave
        _content = State(initialValue: entry.content)
        _selectedMood = State(initialValue: entry.mood)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if let prompt {
                        PromptSection(prompt: prompt)
                    }

                    MoodPickerView(selectedMood: $selectedMood)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Votre réflexion")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        TextEditor(text: $content)
                            .frame(minHeight: 200)
                            .scrollContentBackground(.hidden)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .focused($isTextEditorFocused)
                    }

                    Spacer(minLength: 50)
                }
                .padding()
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(entry.createdAt.relativeFormatted)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        onSave(content, selectedMood)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }

                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Terminé") {
                            isTextEditorFocused = false
                        }
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTextEditorFocused = true
                }
            }
        }
    }
}

private struct PromptSection: View {
    let prompt: DailyPrompt

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(prompt.category.label, systemImage: prompt.category.icon)
                .font(.caption)
                .foregroundStyle(prompt.category.color)

            Text(prompt.text)
                .font(.body)
                .foregroundStyle(.secondary)
                .italic()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(prompt.category.color.opacity(0.1))
        )
    }
}

#Preview {
    EntryEditorView(
        entry: JournalEntry(),
        prompt: DailyPrompt(
            text: "Quelles sont les trois choses pour lesquelles vous êtes reconnaissant aujourd'hui ?",
            category: .gratitude
        )
    ) { _, _ in }
}
