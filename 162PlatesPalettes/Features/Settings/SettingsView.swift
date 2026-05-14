//
//  SettingsView.swift
//  162PlatesPalettes
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: AppDataStore
    @State private var showingResetConfirm = false

    private var version: String {
        let s = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return s ?? "1.0"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppChromeBackground()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        statsHero
                        engageSection
                        
                        dangerSection
                        versionFooter
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
            .navigationTitle("Settings")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .confirmationDialog("Reset all data?", isPresented: $showingResetConfirm, titleVisibility: .visible) {
                Button("Erase everything", role: .destructive) {
                    resetAll()
                }
                Button("Cancel", role: .cancel) {
                    FeedbackService.tap()
                }
            } message: {
                Text("This removes all saved recipes progress, lists, timers, and achievements on this device.")
            }
        }
    }

    private var statsHero: some View {
        ListRowChrome {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.appAccent.opacity(0.35), Color.appPrimary.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                        Image(systemName: "chart.bar.fill")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(Color.appPrimary)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your activity")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(Color.appTextPrimary)
                        Text("Totals on this device")
                            .font(.caption)
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    Spacer(minLength: 0)
                }
                LazyVGrid(
                    columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                    spacing: 10
                ) {
                    statTile("Entries", "\(store.totalEntriesCreated)", "square.and.pencil")
                    statTile("Minutes", "\(store.totalMinutesUsed)", "clock.fill")
                    statTile("Sessions", "\(store.totalSessionsCompleted)", "flame.fill")
                    statTile("Streak", "\(store.streakDays)d", "sun.max.fill")
                }
            }
        }
    }

    private func statTile(_ label: String, _ value: String, _ icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 22)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(Color.appTextSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppDepth.cardFace.opacity(0.45))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.appTextSecondary.opacity(0.08), lineWidth: 1)
                )
        )
    }

    private var engageSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("App")

            VStack(spacing: 0) {
                SettingsAccentRow(
                    icon: "star.fill",
                    title: "Rate us",
                    subtitle: "Enjoying the app? Leave a rating",
                    tint: Color.appAccent
                ) {
                    FeedbackService.tap()
                    SettingsActions.rateApp()
                }
                rowDivider
                SettingsAccentRow(
                    icon: "hand.raised.fill",
                    title: "Privacy Policy",
                    subtitle: "How we handle your data",
                    tint: Color.appPrimary
                ) {
                    FeedbackService.tap()
                    SettingsActions.openExternalURL(.privacyPolicy)
                }
                rowDivider
                SettingsAccentRow(
                    icon: "doc.text.fill",
                    title: "Terms of Use",
                    subtitle: "Conditions for using the app",
                    tint: Color.appPrimary
                ) {
                    FeedbackService.tap()
                    SettingsActions.openExternalURL(.termsOfUse)
                }
            }
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.appSurface.opacity(0.95))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.appAccent.opacity(0.25), Color.appPrimary.opacity(0.12)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .appShadowCard()
        }
    }

    

    private var rowDivider: some View {
        Rectangle()
            .fill(Color.appTextSecondary.opacity(0.12))
            .frame(height: 1)
            .padding(.leading, 58)
    }

    private var dangerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Data")

            Button {
                FeedbackService.tap()
                showingResetConfirm = true
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: "trash.fill")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Color.red.opacity(0.9))
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.red.opacity(0.15))
                        )
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Reset all data")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(Color.red.opacity(0.95))
                        Text("Erase recipes progress, lists, and timers")
                            .font(.caption)
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Color.appTextSecondary.opacity(0.6))
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.appSurface.opacity(0.95))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.red.opacity(0.25), lineWidth: 1)
                )
                .appShadowSoft()
            }
            .buttonStyle(.plain)
        }
    }

    private var versionFooter: some View {
        VStack(spacing: 8) {
            Text("Version \(version)")
                .font(.footnote.weight(.medium))
                .foregroundStyle(Color.appTextSecondary)
            Text("Food & Drink")
                .font(.caption2)
                .foregroundStyle(Color.appTextSecondary.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.subheadline.weight(.bold))
            .foregroundStyle(Color.appTextSecondary)
            .textCase(.uppercase)
            .tracking(0.5)
            .padding(.leading, 4)
    }

    private func resetAll() {
        FeedbackService.warning()
        store.resetAll()
        NotificationCenter.default.post(name: .dataReset, object: nil)
    }
}

private struct SettingsAccentRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 14) {
                Image(systemName: icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(tint)
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(tint.opacity(0.18))
                    )
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Color.appTextSecondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
                Image(systemName: "arrow.up.right.circle.fill")
                    .font(.title3)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.appTextSecondary, Color.appSurface.opacity(0.5))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
