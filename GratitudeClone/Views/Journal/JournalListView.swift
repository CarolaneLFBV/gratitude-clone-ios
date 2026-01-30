//
//  JournalListView.swift
//  GratitudeClone
//

import SwiftUI
import SwiftData

struct JournalListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = JournalViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.entries.isEmpty {
                    EmptyStateView()
                } else {
                    JournalContent(viewModel: viewModel)
                }
            }
            .navigationTitle("Journal")
            .toolbar {
                if !viewModel.entries.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        FilterMenu(viewModel: viewModel)
                    }
                }
            }
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Rechercher..."
            )
            .onAppear {
                viewModel.configure(modelContext: modelContext)
            }
            .refreshable {
                viewModel.fetchEntries()
            }
        }
    }
}

private struct EmptyStateView: View {
    var body: some View {
        ContentUnavailableView(
            "Aucune entrée",
            systemImage: "book.closed",
            description: Text("Commencez à écrire pour voir vos entrées ici.")
        )
    }
}

private struct JournalContent: View {
    @Bindable var viewModel: JournalViewModel

    var body: some View {
        List {
            StatsSection(
                totalEntries: viewModel.totalEntries,
                currentStreak: viewModel.currentStreak
            )

            if viewModel.hasActiveFilters {
                ActiveFiltersSection(viewModel: viewModel)
            }

            ForEach(viewModel.groupedEntries, id: \.0) { month, entries in
                Section(header: Text(month)) {
                    ForEach(entries) { entry in
                        NavigationLink(destination: EntryDetailView(entry: entry)) {
                            JournalEntryRow(entry: entry)
                        }
                    }
                    .onDelete { offsets in
                        viewModel.deleteEntries(at: offsets, in: entries)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

private struct StatsSection: View {
    let totalEntries: Int
    let currentStreak: Int

    var body: some View {
        Section {
            HStack(spacing: 24) {
                StatItem(
                    value: "\(totalEntries)",
                    label: "Entrées",
                    icon: "book.fill",
                    color: .blue
                )

                Divider()

                StatItem(
                    value: "\(currentStreak)",
                    label: "Jours d'affilée",
                    icon: "flame.fill",
                    color: .orange
                )
            }
            .padding(.vertical, 8)
        }
    }
}

private struct StatItem: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ActiveFiltersSection: View {
    @Bindable var viewModel: JournalViewModel

    var body: some View {
        Section {
            HStack {
                Text("Filtres actifs")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Button("Effacer") {
                    viewModel.clearFilters()
                }
                .font(.subheadline)
            }
        }
    }
}

private struct FilterMenu: View {
    @Bindable var viewModel: JournalViewModel

    var body: some View {
        Menu {
            Section("Catégorie") {
                Button {
                    viewModel.selectedCategory = nil
                } label: {
                    Label("Toutes", systemImage: viewModel.selectedCategory == nil ? "checkmark" : "")
                }

                ForEach(PromptCategory.allCases, id: \.self) { category in
                    Button {
                        viewModel.selectedCategory = category
                    } label: {
                        Label(category.label, systemImage: viewModel.selectedCategory == category ? "checkmark" : "")
                    }
                }
            }

            Section("Humeur") {
                Button {
                    viewModel.selectedMood = nil
                } label: {
                    Label("Toutes", systemImage: viewModel.selectedMood == nil ? "checkmark" : "")
                }

                ForEach(Mood.allCases, id: \.self) { mood in
                    Button {
                        viewModel.selectedMood = mood
                    } label: {
                        Label("\(mood.emoji) \(mood.label)", systemImage: viewModel.selectedMood == mood ? "checkmark" : "")
                    }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .symbolVariant(viewModel.hasActiveFilters ? .fill : .none)
        }
        .accessibilityLabel("Filtrer les entrées")
    }
}

#Preview {
    JournalListView()
        .modelContainer(for: [JournalEntry.self, DailyPrompt.self], inMemory: true)
}
