//
//  GroceryItem.swift
//  162PlatesPalettes
//

import Foundation

struct GroceryItem: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var category: GroceryCategory
    var note: String
    var completed: Bool

    init(
        id: UUID = UUID(),
        name: String,
        category: GroceryCategory = .other,
        note: String = "",
        completed: Bool = false
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.note = note
        self.completed = completed
    }
}

enum GroceryCategory: String, Codable, CaseIterable, Identifiable {
    case produce = "Produce"
    case dairy = "Dairy"
    case pantry = "Pantry"
    case meat = "Meat & Fish"
    case bakery = "Bakery"
    case frozen = "Frozen"
    case other = "Other"

    var id: String { rawValue }
}
