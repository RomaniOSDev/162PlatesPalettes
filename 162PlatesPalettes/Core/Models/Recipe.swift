//
//  Recipe.swift
//  162PlatesPalettes
//

import Foundation

struct Recipe: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let cookTimeMinutes: Int
    let ingredients: [String]
    let steps: [String]
}
