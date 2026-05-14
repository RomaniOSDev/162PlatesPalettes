//
//  AchievementModels.swift
//  162PlatesPalettes
//

import Foundation

struct AchievementDisplay: Identifiable {
    let id: String
    let title: String
    let detail: String

    static let all: [AchievementDisplay] = [
        AchievementDisplay(id: "firstTaste", title: "First Taste", detail: "Viewed your first recipe."),
        AchievementDisplay(id: "recipeExplorer", title: "Recipe Explorer", detail: "Viewed ten different recipes."),
        AchievementDisplay(id: "mealPlanner", title: "Meal Planner", detail: "Completed five meal plans."),
        AchievementDisplay(id: "groceryGuru", title: "Grocery Guru", detail: "+50 grocery lists created."),
        AchievementDisplay(id: "favoriteChef", title: "+Favorite Chef", detail: "Added five favorites."),
        AchievementDisplay(id: "superchefFan", title: "Superchef Fan", detail: "Added fifty favorites."),
        AchievementDisplay(id: "cookingStarter", title: "Cooking Starter", detail: "Finished your first timer."),
        AchievementDisplay(id: "timeMaster", title: "Time Master", detail: "+100 timers completed.")
    ]
}

extension AppDataStore {
    func isAchievementUnlocked(id: String) -> Bool {
        achievementsUnlocked[id] != nil
    }

    func isAchievementUnlockedLive(id: String) -> Bool {
        switch id {
        case "firstTaste":
            return viewedRecipeIds.count >= 1
        case "recipeExplorer":
            return viewedRecipeIds.count >= 10
        case "mealPlanner":
            return listsCompleted >= 5
        case "groceryGuru":
            return listsCompleted >= 50
        case "favoriteChef":
            return favouriteAddEvents >= 5
        case "superchefFan":
            return favouriteAddEvents >= 50
        case "cookingStarter":
            return timersFinished >= 1
        case "timeMaster":
            return timersFinished >= 100
        default:
            return achievementsUnlocked[id] != nil
        }
    }
}
