//
//  Mood.swift
//  GratitudeClone
//

import SwiftUI

enum Mood: String, Codable, CaseIterable {
    case veryHappy
    case happy
    case neutral
    case sad
    case verySad

    var emoji: String {
        switch self {
        case .veryHappy: return "😄"
        case .happy: return "🙂"
        case .neutral: return "😐"
        case .sad: return "😔"
        case .verySad: return "😢"
        }
    }

    var color: Color {
        switch self {
        case .veryHappy: return .green
        case .happy: return .mint
        case .neutral: return .gray
        case .sad: return .orange
        case .verySad: return .red
        }
    }

    var label: String {
        switch self {
        case .veryHappy: return "Très heureux"
        case .happy: return "Heureux"
        case .neutral: return "Neutre"
        case .sad: return "Triste"
        case .verySad: return "Très triste"
        }
    }
}
