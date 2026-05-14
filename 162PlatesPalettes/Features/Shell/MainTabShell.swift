//
//  MainTabShell.swift
//  162PlatesPalettes
//

import SwiftUI

struct MainTabShell: View {
    @EnvironmentObject private var store: AppDataStore
    @State private var tab: MainTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch tab {
                case .home:
                    HomeView(
                        goToTab: { destination in
                            tab = destination
                        }
                    )
                case .recipes:
                    RecipesView()
                case .plan:
                    PlanCookContainerView()
                case .achievements:
                    AchievementsView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 78)

            tabBar
        }
    }

    private var tabBar: some View {
        HStack(spacing: 8) {
            ForEach(MainTab.allCases, id: \.self) { item in
                Button {
                    FeedbackService.tap()
                    tab = item
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: item.icon)
                            .font(.system(size: 20))
                        Text(item.label)
                            .font(.caption2.weight(.semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .foregroundStyle(tab == item ? Color.appTextPrimary : Color.appTextSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 4)
                    .background(
                        Group {
                            if tab == item {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(AppDepth.tabSelected)
                            } else {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.appSurface.opacity(0.35))
                            }
                        }
                    )
                    .shadow(
                        color: tab == item ? Color.appPrimary.opacity(0.2) : Color.clear,
                        radius: tab == item ? 6 : 0,
                        x: 0,
                        y: 2
                    )
                }
                .buttonStyle(TabBarButtonStyle())
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .padding(.bottom, 12)
        .background(
            AppDepth.tabBarSurface
                .ignoresSafeArea(edges: .bottom)
                .appShadowTabBar()
        )
    }
}

private struct TabBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
