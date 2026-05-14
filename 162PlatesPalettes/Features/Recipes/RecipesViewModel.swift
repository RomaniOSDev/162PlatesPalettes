//
//  RecipesViewModel.swift
//  162PlatesPalettes
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class RecipesViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedRecipe: Recipe?

    func filteredRecipes(store: AppDataStore) -> [Recipe] {
        let base = RecipeRepository.all.filter { store.dismissedRecipeIds.contains($0.id) == false }
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return base }
        return base.filter { $0.title.localizedCaseInsensitiveContains(trimmed) }
    }

    func exploreTapped(store: AppDataStore) {
        FeedbackService.medium()
        store.markRecipeCatalogExplored()
    }
}
