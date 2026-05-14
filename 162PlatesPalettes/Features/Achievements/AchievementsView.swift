//
//  AchievementsView.swift
//  162PlatesPalettes
//

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var store: AppDataStore

    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    private var unlockedCount: Int {
        AchievementDisplay.all.filter { store.isAchievementUnlockedLive(id: $0.id) }.count
    }

    private var totalCount: Int {
        AchievementDisplay.all.count
    }

    private var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(unlockedCount) / Double(totalCount)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppChromeBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        heroHeader
                        metricsStrip
                        Text("All badges")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(Color.appTextPrimary)
                            .padding(.leading, 4)
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(AchievementDisplay.all) { item in
                                AchievementBadgeTile(
                                    title: item.title,
                                    detail: item.detail,
                                    unlocked: store.isAchievementUnlockedLive(id: item.id)
                                )
                            }
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 8)
                }
            }
            .navigationTitle("Achievements")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private var heroHeader: some View {
        ListRowChrome {
            HStack(alignment: .center, spacing: 18) {
                ZStack {
                    Circle()
                        .stroke(Color.appTextSecondary.opacity(0.2), lineWidth: 6)
                        .frame(width: 88, height: 88)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [Color.appAccent, Color.appPrimary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 88, height: 88)
                        .rotationEffect(.degrees(-90))
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.appAccent, Color.appPrimary],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Progress")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.appTextSecondary)
                        .textCase(.uppercase)
                    Text("\(unlockedCount) of \(totalCount)")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)
                    Text(progressHint)
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }
        }
    }

    private var progressHint: String {
        if unlockedCount >= totalCount {
            return "Every badge unlocked — legend status."
        }
        if unlockedCount == 0 {
            return "View recipes, plan trips, and use timers to earn your first star."
        }
        return "Keep cooking to unlock the rest."
    }

    private var metricsStrip: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            metricPill("Recipes explored", value: "\(store.recipesViewed)", symbol: "book.fill")
            metricPill("Lists completed", value: "\(store.listsCompleted)", symbol: "cart.fill")
            metricPill("Timers finished", value: "\(store.timersFinished)", symbol: "timer")
            metricPill("Favorites added", value: "\(store.favouriteAddEvents)", symbol: "heart.fill")
        }
    }

    private func metricPill(_ label: String, value: String, symbol: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.appAccent.opacity(0.14))
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppDepth.cardFace.opacity(0.88))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.appPrimary.opacity(0.14), lineWidth: 1)
                )
        )
        .appShadowSoft()
    }
}

private struct AchievementBadgeTile: View {
    let title: String
    let detail: String
    let unlocked: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    Circle()
                        .fill(unlocked ? Color.appPrimary.opacity(0.22) : Color.appBackground.opacity(0.6))
                        .frame(width: 48, height: 48)
                    Image(systemName: unlocked ? "star.fill" : "star")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(
                            unlocked
                                ? LinearGradient(
                                    colors: [Color.appAccent, Color.appPrimary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(
                                    colors: [Color.appTextSecondary, Color.appTextSecondary],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                        )
                }
                Spacer(minLength: 0)
                if unlocked {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Color.appPrimary)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.appTextSecondary.opacity(0.6))
                }
            }
            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color.appTextPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
            Text(detail)
                .font(.caption)
                .foregroundStyle(unlocked ? Color.appTextSecondary : Color.appTextSecondary.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.appSurface.opacity(unlocked ? 0.95 : 0.65))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(
                    unlocked
                        ? LinearGradient(
                            colors: [Color.appAccent.opacity(0.45), Color.appPrimary.opacity(0.25)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            colors: [Color.appTextSecondary.opacity(0.15), Color.appTextSecondary.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                    lineWidth: unlocked ? 1.5 : 1
                )
        )
        .shadow(color: unlocked ? Color.appPrimary.opacity(0.08) : Color.clear, radius: 8, x: 0, y: 3)
    }
}
