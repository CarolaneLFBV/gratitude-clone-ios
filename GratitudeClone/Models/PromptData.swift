//
//  PromptData.swift
//  GratitudeClone
//

import Foundation

struct PromptData: Codable {
    let text: String
    let category: PromptCategory
}

struct PromptsFile: Codable {
    let prompts: [PromptData]
}
