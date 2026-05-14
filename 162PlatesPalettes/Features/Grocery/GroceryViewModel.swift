//
//  GroceryViewModel.swift
//  162PlatesPalettes
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class GroceryViewModel: ObservableObject {
    @Published var expanded: Set<GroceryCategory> = Set(GroceryCategory.allCases)
    @Published var showingAdd = false
    @Published var editingItem: GroceryItem?
    @Published var completePulseId: UUID?

    func toggleCategory(_ c: GroceryCategory) {
        FeedbackService.tap()
        if expanded.contains(c) {
            expanded.remove(c)
        } else {
            expanded.insert(c)
        }
    }

    func isExpanded(_ c: GroceryCategory) -> Bool {
        expanded.contains(c)
    }

    func items(in category: GroceryCategory, store: AppDataStore) -> [GroceryItem] {
        store.groceryItems.filter { $0.category == category }.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
