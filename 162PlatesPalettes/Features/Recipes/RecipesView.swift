//
//  RecipesView.swift
//  162PlatesPalettes
//

import SwiftUI

struct RecipesView: View {
    @EnvironmentObject private var store: AppDataStore
    @StateObject private var model = RecipesViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                AppChromeBackground()
                Group {
                    if store.recipeCatalogExplored == false {
                        firstLaunchEmpty
                    } else if model.filteredRecipes(store: store).isEmpty {
                        searchEmpty
                    } else {
                        recipeList
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(item: $model.selectedRecipe) { recipe in
                RecipeDetailSheet(recipe: recipe)
                    .environmentObject(store)
            }
        }
    }

    private var recipeList: some View {
        List {
            Section {
                AppSearchBar(text: $model.searchText, placeholder: "Search recipes")
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 6, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            Section {
                ForEach(model.filteredRecipes(store: store)) { recipe in
                    Button {
                        FeedbackService.tap()
                        model.selectedRecipe = recipe
                    } label: {
                        RecipeCardRow(recipe: recipe)
                    }
                    .buttonStyle(.plain)
                    .recipeListCardSizing()
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            markFavorite(recipe)
                        } label: {
                            Label("Favorite", systemImage: "heart.fill")
                        }
                        .tint(Color.appPrimary)
                        Button {
                            dismissRecipe(recipe)
                        } label: {
                            Label("Dismiss", systemImage: "xmark.circle.fill")
                        }
                        .tint(Color.appAccent)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var firstLaunchEmpty: some View {
        ScrollView {
            VStack(spacing: 28) {
                UtensilsIllustration()
                    .frame(height: 200)
                EmptyHero(
                    systemImage: "flame.fill",
                    title: "Discover something new",
                    subtitle: "Start your culinary adventure by discovering new recipes!"
                )
                Button {
                    model.exploreTapped(store: store)
                } label: {
                    Text("Explore New Recipes")
                        .font(.headline)
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(AppDepth.primaryCTAGlow)
                        )
                        .appShadowPrimaryGlow()
                }
                .buttonStyle(PressableTapButtonStyle())
                .accessibilityHint("Shows the recipe catalog")
            }
            .padding(.vertical, 36)
            .padding(.horizontal, 20)
        }
    }

    private var searchEmpty: some View {
        ScrollView {
            VStack(spacing: 22) {
                AppSearchBar(text: $model.searchText, placeholder: "Search recipes")
                    .padding(.horizontal, 4)
                Image(systemName: "book.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(
                        LinearGradient(colors: [Color.appAccent, Color.appPrimary], startPoint: .top, endPoint: .bottom)
                    )
                    .appShadowIconGlow()
                Text("Browse our collection and find your next favorite dish!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.appTextSecondary)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)
        }
    }

    private func markFavorite(_ recipe: Recipe) {
        FeedbackService.medium()
        FeedbackService.playSystemSound(1103)
        store.toggleFavorite(recipeId: recipe.id)
    }

    private func dismissRecipe(_ recipe: Recipe) {
        FeedbackService.tap()
        store.dismissRecipeSuggestion(recipeId: recipe.id)
    }
}

private struct PressableTapButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

private struct UtensilsIllustration: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.appAccent.opacity(0.5), lineWidth: 5)
                .frame(width: 180, height: 180)
            Path { p in
                p.move(to: CGPoint(x: 80, y: 60))
                p.addQuadCurve(to: CGPoint(x: 120, y: 120), control: CGPoint(x: 140, y: 70))
            }
            .stroke(Color.appPrimary, style: StrokeStyle(lineWidth: 6, lineCap: .round))
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 70))
                .foregroundStyle(Color.appAccent)
        }
    }
}
