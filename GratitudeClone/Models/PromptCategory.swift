//
//  PromptCategory.swift
//  GratitudeClone
//

import SwiftUI

enum PromptCategory: String, Codable, CaseIterable {
    case gratitude
    case reflection
    case growth
    case mindfulness
    case relationships
    case goals

    var label: String {
        switch self {
        case .gratitude: return "Gratitude"
        case .reflection: return "Réflexion"
        case .growth: return "Croissance"
        case .mindfulness: return "Pleine conscience"
        case .relationships: return "Relations"
        case .goals: return "Objectifs"
        }
    }

    var icon: String {
        switch self {
        case .gratitude: return "heart.fill"
        case .reflection: return "brain.head.profile"
        case .growth: return "leaf.fill"
        case .mindfulness: return "sparkles"
        case .relationships: return "person.2.fill"
        case .goals: return "target"
        }
    }

    var color: Color {
        switch self {
        case .gratitude: return .pink
        case .reflection: return .purple
        case .growth: return .green
        case .mindfulness: return .cyan
        case .relationships: return .orange
        case .goals: return .blue
        }
    }
}
