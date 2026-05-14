//
//  HomeView.swift
//  162PlatesPalettes
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppDataStore
    var goToTab: (MainTab) -> Void

    @State private var recipeDetail: Recipe?

    private var groceryPending: Int {
        store.groceryItems.filter { $0.completed == false }.count
    }

    private var activeTimers: Int {
        store.dishTimers.filter { $0.status == .running || $0.status == .paused }.count
    }

    private var badgesUnlocked: Int {
        AchievementDisplay.all.filter { store.isAchievementUnlockedLive(id: $0.id) }.count
    }

    private let badgeTotal = AchievementDisplay.all.count

    private var spotlightRecipe: Recipe {
        let pool = RecipeRepository.all.filter { store.dismissedRecipeIds.contains($0.id) == false }
        guard pool.isEmpty == false else { return RecipeRepository.all[0] }
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return pool[day % pool.count]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppChromeBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        hero
                        widgetGrid
                        recipesStrip
                        spotlightCard
                    }
                    .padding(.bottom, 28)
                }
            }
            .navigationTitle("Home")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(item: $recipeDetail) { recipe in
                RecipeDetailSheet(recipe: recipe)
                    .environmentObject(store)
            }
        }
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            Image("HomeHeroBanner")
                .resizable()
                .scaledToFill()
                .frame(height: 168)
                .clipped()

            LinearGradient(
                colors: [Color.black.opacity(0.75), Color.black.opacity(0.15), Color.clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 168)

            VStack(alignment: .leading, spacing: 6) {
                Text(greetingLine)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.appAccent)
                Text("Cook with confidence")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                Text("Recipes, shopping, and timers in one flow.")
                    .font(.footnote)
                    .foregroundStyle(Color.appTextSecondary)
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.appAccent.opacity(0.35), Color.appPrimary.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .appShadowCard()
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var greetingLine: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let prefix: String
        if hour < 12 { prefix = "Good morning" }
        else if hour < 17 { prefix = "Good afternoon" }
        else { prefix = "Good evening" }
        if store.streakDays > 0 {
            return "\(prefix) · \(store.streakDays) day streak"
        }
        return prefix
    }

    private var widgetGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
            spacing: 12
        ) {
            HomeWidgetTile(
                title: "Grocery",
                subtitle: groceryPending == 0 ? "All done" : "\(groceryPending) left",
                artName: "WidgetGroceriesArt"
            ) {
                FeedbackService.tap()
                NotificationCenter.default.post(
                    name: .planCookOpenSegment,
                    object: nil,
                    userInfo: [PlanCookSegmentKey.segment: PlanCookSegmentValue.groceries]
                )
                goToTab(.plan)
            }

            HomeWidgetTile(
                title: "Timers",
                subtitle: activeTimers == 0 ? "None running" : "\(activeTimers) active",
                artName: "WidgetTimersArt"
            ) {
                FeedbackService.tap()
                NotificationCenter.default.post(
                    name: .planCookOpenSegment,
                    object: nil,
                    userInfo: [PlanCookSegmentKey.segment: PlanCookSegmentValue.timers]
                )
                goToTab(.plan)
            }

            HomeWidgetTile(
                title: "Badges",
                subtitle: "\(badgesUnlocked)/\(badgeTotal)",
                artName: "WidgetBadgesArt"
            ) {
                FeedbackService.tap()
                goToTab(.achievements)
            }

            HomeWidgetTile(
                title: "Recipes",
                subtitle: store.recipeCatalogExplored ? "Browse the catalog" : "Open collection",
                artName: "RecipeSpotlight2"
            ) {
                FeedbackService.tap()
                goToTab(.recipes)
            }
        }
        .padding(.horizontal, 16)
    }

    private var recipesStrip: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Pick something tonight")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                Spacer(minLength: 0)
                Button {
                    FeedbackService.tap()
                    goToTab(.recipes)
                } label: {
                    Label("See all", systemImage: "arrow.right.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.appPrimary)
                }
            }
            .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(previewRecipes) { recipe in
                        HomeRecipeChip(recipe: recipe, artName: spotlightImageName(for: recipe.id)) {
                            FeedbackService.tap()
                            recipeDetail = recipe
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private var previewRecipes: [Recipe] {
        Array(RecipeRepository.all.filter { store.dismissedRecipeIds.contains($0.id) == false }.prefix(6))
    }

    private var spotlightCard: some View {
        let r = spotlightRecipe
        return VStack(alignment: .leading, spacing: 12) {
            Text("Today's pick")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.appTextPrimary)
                .padding(.horizontal, 16)

            Button {
                FeedbackService.tap()
                recipeDetail = r
            } label: {
                ZStack(alignment: .bottomLeading) {
                    Image(spotlightImageName(for: r.id))
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipped()

                    LinearGradient(
                        colors: [Color.black.opacity(0.72), Color.black.opacity(0.05), Color.clear],
                        startPoint: .bottom,
                        endPoint: .center
                    )

                    VStack(alignment: .leading, spacing: 6) {
                        Text(r.title)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Color.appTextPrimary)
                            .multilineTextAlignment(.leading)
                        HStack(spacing: 8) {
                            Image(systemName: "clock.fill")
                            Text("\(r.cookTimeMinutes) min")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Color.appAccent)
                    }
                    .padding(18)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.appAccent.opacity(0.4), Color.appPrimary.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .appShadowCard()
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
        }
    }
}

private func spotlightImageName(for recipeId: String) -> String {
    let pool = ["RecipeSpotlight1", "RecipeSpotlight2", "RecipeSpotlight3", "RecipeSpotlight4"]
    if let idx = RecipeRepository.all.firstIndex(where: { $0.id == recipeId }) {
        return pool[idx % pool.count]
    }
    return pool[0]
}

// MARK: - Tiles

private struct HomeWidgetTile: View {
    let title: String
    let subtitle: String
    let artName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                Image(artName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 118)
                    .clipped()

                LinearGradient(
                    colors: [Color.black.opacity(0.82), Color.black.opacity(0.2)],
                    startPoint: .bottom,
                    endPoint: .top
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                    Text(subtitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.appTextSecondary)
                }
                .padding(12)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.appAccent.opacity(0.22), lineWidth: 1)
            )
            .appShadowSoft()
        }
        .buttonStyle(.plain)
    }
}

private struct HomeRecipeChip: View {
    let recipe: Recipe
    let artName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                Image(artName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 100)
                    .clipped()

                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(2)
                    Text("\(recipe.cookTimeMinutes) min")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color.appTextSecondary)
                }
                .frame(width: 140, alignment: .leading)
                .padding(10)
                .background(AppDepth.cardFace.opacity(0.95))
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.appAccent.opacity(0.22), lineWidth: 1)
            )
            .appShadowSoft()
        }
        .buttonStyle(.plain)
    }
}
