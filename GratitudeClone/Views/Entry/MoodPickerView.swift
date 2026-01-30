//
//  MoodPickerView.swift
//  GratitudeClone
//

import SwiftUI

struct MoodPickerView: View {
    @Binding var selectedMood: Mood?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comment vous sentez-vous ?")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    MoodButton(
                        mood: mood,
                        isSelected: selectedMood == mood
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            if selectedMood == mood {
                                selectedMood = nil
                            } else {
                                selectedMood = mood
                            }
                        }
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Sélecteur d'humeur")
    }
}

private struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(mood.emoji)
                    .font(.title)
                    .scaleEffect(isSelected ? 1.2 : 1.0)

                if isSelected {
                    Text(mood.label)
                        .font(.caption2)
                        .foregroundStyle(mood.color)
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .frame(minWidth: 50)
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? mood.color.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(mood.label)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    MoodPickerView(selectedMood: .constant(.happy))
        .padding()
}
