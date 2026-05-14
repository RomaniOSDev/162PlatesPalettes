//
//  RecipeDetailSheet.swift
//  162PlatesPalettes
//

import SwiftUI

struct RecipeDetailSheet: View {
    let recipe: Recipe
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AppChromeBackground()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ListRowChrome {
                            HStack(alignment: .center, spacing: 16) {
                                RecipeThumbnailCanvas(recipeId: recipe.id)
                                    .frame(width: 88, height: 88)
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(recipe.title)
                                        .font(.title3.weight(.bold))
                                        .foregroundStyle(Color.appTextPrimary)
                                    Label("\(recipe.cookTimeMinutes) min", systemImage: "clock.fill")
                                        .foregroundStyle(Color.appTextSecondary)
                                        .font(.subheadline.weight(.medium))
                                }
                                Spacer(minLength: 0)
                            }
                        }
                        ListRowChrome {
                            VStack(alignment: .leading, spacing: 12) {
                                sectionTitle("Ingredients")
                                ForEach(recipe.ingredients, id: \.self) { line in
                                    Text("• \(line)")
                                        .foregroundStyle(Color.appTextSecondary)
                                }
                            }
                        }
                        ListRowChrome {
                            VStack(alignment: .leading, spacing: 12) {
                                sectionTitle("Steps")
                                ForEach(Array(recipe.steps.enumerated()), id: \.offset) { idx, line in
                                    Text("\(idx + 1). \(line)")
                                        .foregroundStyle(Color.appTextSecondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
            .navigationTitle(recipe.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        FeedbackService.tap()
                        dismiss()
                    }
                    .foregroundStyle(Color.appPrimary)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        toggleFavorite()
                    } label: {
                        Image(systemName: store.isFavorite(recipe.id) ? "heart.fill" : "heart")
                            .foregroundStyle(Color.appAccent)
                    }
                    .accessibilityLabel("Favorite")
                }
            }
        }
        .onAppear {
            _ = store.registerRecipeViewed(recipeId: recipe.id)
        }
    }

    private func sectionTitle(_ s: String) -> some View {
        Text(s)
            .font(.headline.weight(.bold))
            .foregroundStyle(Color.appTextPrimary)
    }

    private func toggleFavorite() {
        FeedbackService.tap()
        store.toggleFavorite(recipeId: recipe.id)
    }
}
