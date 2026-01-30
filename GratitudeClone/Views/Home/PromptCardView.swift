//
//  PromptCardView.swift
//  GratitudeClone
//

import SwiftUI

struct PromptCardView: View {
    let prompt: DailyPrompt
    var onChangePrompt: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label(prompt.category.label, systemImage: prompt.category.icon)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(prompt.category.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(prompt.category.color.opacity(0.15))
                    )

                Spacer()

                if let onChangePrompt {
                    Button {
                        onChangePrompt()
                    } label: {
                        Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(Color(.systemGray5))
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Changer la phrase de réflexion")
                }

                Image(systemName: "sparkles")
                    .foregroundStyle(.yellow)
            }

            Text(prompt.text)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Prompt du jour: \(prompt.text)")
    }
}

#Preview {
    PromptCardView(
        prompt: DailyPrompt(
            text: "Quelles sont les trois choses pour lesquelles vous êtes reconnaissant aujourd'hui ?",
            category: .gratitude
        ),
        onChangePrompt: { print("Change prompt") }
    )
    .padding()
}
