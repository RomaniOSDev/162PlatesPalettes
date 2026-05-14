//
//  AppStorage.swift
//  162PlatesPalettes
//

import Foundation
import Combine

@MainActor
final class AppDataStore: ObservableObject {

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()

    private enum Keys {
        static let hasSeenOnboarding = "pp.hasSeenOnboarding"
        static let favoriteRecipes = "pp.favoriteRecipes"
        static let recentlyViewed = "pp.recentlyViewed"
        static let dismissedRecipeIds = "pp.dismissedRecipeIds"
        static let groceryItems = "pp.groceryItems"
        static let dishTimers = "pp.dishTimers"
        static let timerSoundEnabled = "pp.timerSoundEnabled"
        static let viewedRecipeIds = "pp.viewedRecipeIds"
        static let listsCompleted = "pp.listsCompleted"
        static let favouriteAddEvents = "pp.favouriteAddEvents"
        static let timersFinished = "pp.timersFinished"
        static let totalSessionsCompleted = "pp.totalSessionsCompleted"
        static let totalMinutesUsed = "pp.totalMinutesUsed"
        static let streakDays = "pp.streakDays"
        static let lastActivityDate = "pp.lastActivityDate"
        static let achievementsUnlocked = "pp.achievementsUnlocked"
        static let recipeCatalogExplored = "pp.recipeCatalogExplored"
        static let totalEntriesCreated = "pp.totalEntriesCreated"
    }

    @Published private(set) var hasSeenOnboarding: Bool
    @Published private(set) var favoriteRecipeIds: [String]
    @Published private(set) var recentlyViewedRecipeIds: [String]
    @Published private(set) var dismissedRecipeIds: [String]
    @Published private(set) var groceryItems: [GroceryItem]
    @Published private(set) var dishTimers: [DishTimerModel]
    @Published private(set) var timerSoundEnabled: Bool
    @Published private(set) var viewedRecipeIds: [String]
    @Published private(set) var listsCompleted: Int
    @Published private(set) var favouriteAddEvents: Int
    @Published private(set) var timersFinished: Int
    @Published private(set) var totalSessionsCompleted: Int
    @Published private(set) var totalMinutesUsed: Int
    @Published private(set) var streakDays: Int
    @Published private(set) var lastActivityDate: Date?
    @Published private(set) var achievementsUnlocked: [String: Date]
    @Published private(set) var recipeCatalogExplored: Bool
    @Published private(set) var totalEntriesCreated: Int

    var recipesViewed: Int { viewedRecipeIds.count }

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
        hasSeenOnboarding = userDefaults.bool(forKey: Keys.hasSeenOnboarding)
        favoriteRecipeIds = Self.decodeArray(String.self, from: userDefaults.data(forKey: Keys.favoriteRecipes)) ?? []
        recentlyViewedRecipeIds = Self.decodeArray(String.self, from: userDefaults.data(forKey: Keys.recentlyViewed)) ?? []
        dismissedRecipeIds = Self.decodeArray(String.self, from: userDefaults.data(forKey: Keys.dismissedRecipeIds)) ?? []
        groceryItems = Self.decodeArray(GroceryItem.self, from: userDefaults.data(forKey: Keys.groceryItems)) ?? []
        dishTimers = Self.decodeArray(DishTimerModel.self, from: userDefaults.data(forKey: Keys.dishTimers)) ?? []
        timerSoundEnabled = userDefaults.object(forKey: Keys.timerSoundEnabled) as? Bool ?? true
        viewedRecipeIds = Self.decodeArray(String.self, from: userDefaults.data(forKey: Keys.viewedRecipeIds)) ?? []
        listsCompleted = userDefaults.integer(forKey: Keys.listsCompleted)
        favouriteAddEvents = userDefaults.integer(forKey: Keys.favouriteAddEvents)
        timersFinished = userDefaults.integer(forKey: Keys.timersFinished)
        totalSessionsCompleted = userDefaults.integer(forKey: Keys.totalSessionsCompleted)
        totalMinutesUsed = userDefaults.integer(forKey: Keys.totalMinutesUsed)
        streakDays = userDefaults.integer(forKey: Keys.streakDays)
        if let t = userDefaults.object(forKey: Keys.lastActivityDate) as? Double {
            lastActivityDate = Date(timeIntervalSince1970: t)
        } else {
            lastActivityDate = nil
        }
        achievementsUnlocked = Self.decodeDictionary(from: userDefaults.data(forKey: Keys.achievementsUnlocked)) ?? [:]
        recipeCatalogExplored = userDefaults.bool(forKey: Keys.recipeCatalogExplored)
        totalEntriesCreated = userDefaults.integer(forKey: Keys.totalEntriesCreated)
    }

    func setHasSeenOnboarding(_ value: Bool) {
        hasSeenOnboarding = value
        defaults.set(value, forKey: Keys.hasSeenOnboarding)
    }

    func markRecipeCatalogExplored() {
        recipeCatalogExplored = true
        defaults.set(true, forKey: Keys.recipeCatalogExplored)
    }

    @discardableResult
    func registerRecipeViewed(recipeId: String) -> [String] {
        if viewedRecipeIds.contains(recipeId) == false {
            viewedRecipeIds.append(recipeId)
            if let data = try? encoder.encode(viewedRecipeIds) {
                defaults.set(data, forKey: Keys.viewedRecipeIds)
            }
        }
        touchRecent(recipeId: recipeId)
        recordActivity()
        return checkAchievements()
    }

    func toggleFavorite(recipeId: String) {
        let wasFavorite = favoriteRecipeIds.contains(recipeId)
        if wasFavorite {
            favoriteRecipeIds.removeAll { $0 == recipeId }
        } else {
            favoriteRecipeIds.append(recipeId)
            favouriteAddEvents += 1
            defaults.set(favouriteAddEvents, forKey: Keys.favouriteAddEvents)
        }
        if let data = try? encoder.encode(favoriteRecipeIds) {
            defaults.set(data, forKey: Keys.favoriteRecipes)
        }
        if wasFavorite == false {
            recordActivity()
        }
        _ = checkAchievements()
    }

    func isFavorite(_ recipeId: String) -> Bool {
        favoriteRecipeIds.contains(recipeId)
    }

    func dismissRecipeSuggestion(recipeId: String) {
        if dismissedRecipeIds.contains(recipeId) == false {
            dismissedRecipeIds.append(recipeId)
            if let data = try? encoder.encode(dismissedRecipeIds) {
                defaults.set(data, forKey: Keys.dismissedRecipeIds)
            }
        }
    }

    private func touchRecent(recipeId: String) {
        var next = recentlyViewedRecipeIds.filter { $0 != recipeId }
        next.insert(recipeId, at: 0)
        if next.count > 25 {
            next = Array(next.prefix(25))
        }
        recentlyViewedRecipeIds = next
        if let data = try? encoder.encode(recentlyViewedRecipeIds) {
            defaults.set(data, forKey: Keys.recentlyViewed)
        }
    }

    func replaceGroceryItems(_ items: [GroceryItem]) {
        groceryItems = items
        if let data = try? encoder.encode(items) {
            defaults.set(data, forKey: Keys.groceryItems)
        }
    }

    func addGroceryItem(_ item: GroceryItem) {
        var items = groceryItems
        items.append(item)
        replaceGroceryItems(items)
        totalEntriesCreated += 1
        defaults.set(totalEntriesCreated, forKey: Keys.totalEntriesCreated)
        recordActivity()
    }

    func updateGroceryItem(id: UUID, transform: (inout GroceryItem) -> Void) {
        var items = groceryItems
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        transform(&items[idx])
        replaceGroceryItems(items)
    }

    func deleteGroceryItem(id: UUID) {
        groceryItems.removeAll { $0.id == id }
        if let data = try? encoder.encode(groceryItems) {
            defaults.set(data, forKey: Keys.groceryItems)
        }
    }

    func completeGroceryTrip() {
        listsCompleted += 1
        defaults.set(listsCompleted, forKey: Keys.listsCompleted)
        totalSessionsCompleted += 1
        defaults.set(totalSessionsCompleted, forKey: Keys.totalSessionsCompleted)
        groceryItems = []
        if let data = try? encoder.encode(groceryItems) {
            defaults.set(data, forKey: Keys.groceryItems)
        }
        recordActivity()
        _ = checkAchievements()
    }

    func replaceDishTimers(_ timers: [DishTimerModel]) {
        dishTimers = timers
        if let data = try? encoder.encode(timers) {
            defaults.set(data, forKey: Keys.dishTimers)
        }
    }

    func addDishTimer(_ timer: DishTimerModel) {
        var timers = dishTimers
        timers.append(timer)
        replaceDishTimers(timers)
        totalEntriesCreated += 1
        defaults.set(totalEntriesCreated, forKey: Keys.totalEntriesCreated)
        recordActivity()
    }

    func setTimerSoundEnabled(_ value: Bool) {
        timerSoundEnabled = value
        defaults.set(value, forKey: Keys.timerSoundEnabled)
    }

    @discardableResult
    func incrementTimersFinished(minutesRounded: Int) -> [String] {
        timersFinished += 1
        defaults.set(timersFinished, forKey: Keys.timersFinished)
        totalMinutesUsed += max(1, minutesRounded)
        defaults.set(totalMinutesUsed, forKey: Keys.totalMinutesUsed)
        totalSessionsCompleted += 1
        defaults.set(totalSessionsCompleted, forKey: Keys.totalSessionsCompleted)
        recordActivity()
        return checkAchievements()
    }

    func recordActivity() {
        let cal = Calendar.current
        let now = Date()
        if let last = lastActivityDate {
            if cal.isDate(last, inSameDayAs: now) {
                // Same day — keep streak
            } else if cal.isDateInYesterday(last) {
                streakDays += 1
            } else {
                streakDays = 1
            }
        } else {
            streakDays = 1
        }
        lastActivityDate = now
        if let t = lastActivityDate?.timeIntervalSince1970 {
            defaults.set(t, forKey: Keys.lastActivityDate)
        }
        defaults.set(streakDays, forKey: Keys.streakDays)
    }

    private func persistAchievements() {
        if let data = try? encoder.encode(achievementsUnlocked) {
            defaults.set(data, forKey: Keys.achievementsUnlocked)
        }
    }

    @discardableResult
    private func checkAchievements() -> [String] {
        let specs: [(String, Bool)] = [
            ("firstTaste", viewedRecipeIds.count >= 1),
            ("recipeExplorer", viewedRecipeIds.count >= 10),
            ("mealPlanner", listsCompleted >= 5),
            ("groceryGuru", listsCompleted >= 50),
            ("favoriteChef", favouriteAddEvents >= 5),
            ("superchefFan", favouriteAddEvents >= 50),
            ("cookingStarter", timersFinished >= 1),
            ("timeMaster", timersFinished >= 100)
        ]
        var unlocked: [String] = []
        for (aid, ok) in specs where ok {
            if achievementsUnlocked[aid] == nil {
                achievementsUnlocked[aid] = Date()
                unlocked.append(aid)
            }
        }
        if unlocked.isEmpty == false {
            persistAchievements()
            AchievementBus.unlocked.send(unlocked)
        }
        return unlocked
    }

    /// Completes timers whose fire date passed while the app was not updating UI; settles counters.
    @discardableResult
    func reconcileTimersAfterForeground(now: Date = Date()) -> [UUID] {
        var updated = dishTimers
        var completionIds: [UUID] = []
        for i in updated.indices {
            if updated[i].status == .running, let end = updated[i].fireDate, end <= now {
                let mins = max(1, updated[i].totalSeconds / 60)
                updated[i].status = .completed
                updated[i].remainingSeconds = 0
                updated[i].fireDate = nil
                completionIds.append(updated[i].id)
                _ = incrementTimersFinished(minutesRounded: mins)
            }
        }
        if updated != dishTimers {
            replaceDishTimers(updated)
        }
        return completionIds
    }

    func pauseRunningTimersForBackground(now: Date = Date()) {
        var updated = dishTimers
        for i in updated.indices {
            if updated[i].status == .running, let end = updated[i].fireDate {
                let remaining = Int(round(end.timeIntervalSince(now)))
                updated[i].remainingSeconds = max(0, remaining)
                updated[i].fireDate = nil
                updated[i].status = .paused
            }
        }
        replaceDishTimers(updated)
    }

    func resetAll() {
        let dict = defaults.dictionaryRepresentation()
        for key in dict.keys where key.hasPrefix("pp.") {
            defaults.removeObject(forKey: key)
        }
        hasSeenOnboarding = false
        favoriteRecipeIds = []
        recentlyViewedRecipeIds = []
        dismissedRecipeIds = []
        groceryItems = []
        dishTimers = []
        timerSoundEnabled = true
        viewedRecipeIds = []
        listsCompleted = 0
        favouriteAddEvents = 0
        timersFinished = 0
        totalSessionsCompleted = 0
        totalMinutesUsed = 0
        streakDays = 0
        lastActivityDate = nil
        achievementsUnlocked = [:]
        recipeCatalogExplored = false
        totalEntriesCreated = 0
    }

    private static func decodeArray<T: Decodable>(_ type: T.Type, from data: Data?) -> [T]? {
        guard let data else { return nil }
        return try? JSONDecoder().decode([T].self, from: data)
    }

    private static func decodeDictionary(from data: Data?) -> [String: Date]? {
        guard let data else { return nil }
        return try? JSONDecoder().decode([String: Date].self, from: data)
    }
}
