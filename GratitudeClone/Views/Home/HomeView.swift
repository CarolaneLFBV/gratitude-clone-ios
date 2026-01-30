//
//  HomeView.swift
//  GratitudeClone
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(PromptService.self) private var promptService
    @State private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    GreetingSection(greeting: viewModel.greeting)

                    if let prompt = viewModel.todaysPrompt {
                        PromptCardView(prompt: prompt) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.changePrompt()
                            }
                        }
                    }

                    ActionButton(
                        hasWrittenToday: viewModel.hasWrittenToday,
                        mood: viewModel.todaysEntry?.mood
                    ) {
                        viewModel.createOrEditEntry()
                    }

                    if let entry = viewModel.todaysEntry, !entry.content.isEmpty {
                        TodaysEntrySummary(entry: entry)
                    }

                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Journal")
            .sheet(isPresented: $viewModel.isShowingEditor) {
                if let entry = viewModel.todaysEntry {
                    EntryEditorView(
                        entry: entry,
                        prompt: viewModel.todaysPrompt
                    ) { content, mood in
                        viewModel.saveEntry(content: content, mood: mood)
                    }
                }
            }
            .onAppear {
                viewModel.configure(modelContext: modelContext, promptService: promptService)
            }
            .refreshable {
                viewModel.refreshData()
            }
        }
    }
}

private struct GreetingSection: View {
    let greeting: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greeting)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(Date().formatted(date: .complete, time: .omitted))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct ActionButton: View {
    let hasWrittenToday: Bool
    let mood: Mood?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if hasWrittenToday {
                    if let mood {
                        Text(mood.emoji)
                            .font(.title2)
                    }
                    Text("Modifier mon entrée")
                } else {
                    Image(systemName: "pencil.line")
                        .font(.title2)
                    Text("Commencer à écrire")
                }
            }
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(hasWrittenToday ? Color.green : Color.accentColor)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(hasWrittenToday ? "Modifier l'entrée d'aujourd'hui" : "Créer une nouvelle entrée")
    }
}

private struct TodaysEntrySummary: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Votre réflexion d'aujourd'hui")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(entry.updatedAt.timeFormatted)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Text(entry.content)
                .font(.body)
                .lineLimit(3)
                .foregroundStyle(.primary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [JournalEntry.self, DailyPrompt.self], inMemory: true)
        .environment(PromptService())
}
