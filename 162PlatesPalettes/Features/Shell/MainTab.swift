//
//  MainTab.swift
//  162PlatesPalettes
//

enum MainTab: Int, CaseIterable, Hashable {
    case home
    case recipes
    case plan
    case achievements
    case settings

    var label: String {
        switch self {
        case .home: return "Home"
        case .recipes: return "Recipes"
        case .plan: return "Plan"
        case .achievements: return "Badges"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .recipes: return "book.fill"
        case .plan: return "basket.fill"
        case .achievements: return "star.fill"
        case .settings: return "gearshape.fill"
        }
    }
}
