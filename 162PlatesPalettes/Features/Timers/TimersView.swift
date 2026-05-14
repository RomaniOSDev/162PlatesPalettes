//
//  TimersView.swift
//  162PlatesPalettes
//

import Combine
import SwiftUI

struct TimersView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var model = TimersViewModel()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                AppChromeBackground()
                Group {
                    if store.dishTimers.isEmpty {
                        emptyState
                    } else if scenePhase == .active {
                        TimelineView(.periodic(from: .now, by: 0.25)) { timeline in
                            timersList(now: timeline.date)
                        }
                    } else {
                        timersList(now: Date())
                    }
                }
                Button {
                    FeedbackService.tap()
                    model.showingAdd = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 52))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.appTextPrimary, Color.appPrimary)
                        .appShadowPrimaryGlow()
                        .frame(width: 64, height: 64)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 24)
                .accessibilityLabel("Add timer")
            }
            .navigationTitle("Cooking Timers")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $model.showingAdd) {
                AddTimerSheet()
                    .environmentObject(store)
            }
            .onReceive(NotificationCenter.default.publisher(for: .dataReset)) { _ in
                model.showingAdd = false
            }
        }
    }

    private func timersList(now: Date) -> some View {
        List {
            ForEach(store.dishTimers) { timer in
                TimerCard(
                    timer: timer,
                    now: now,
                    sceneActive: scenePhase == .active,
                    scalePulse: model.scalePulseId == timer.id,
                    onStart: { model.start(timer, store: store, now: now) },
                    onPause: { model.pause(timer, store: store, now: now) },
                    onReset: { model.reset(timer, store: store) },
                    onComplete: { model.complete(timer: timer, store: store) },
                    onDelete: { model.delete(id: timer.id, store: store) }
                )
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var emptyState: some View {
        ScrollView {
            VStack(spacing: 28) {
                EmptyHero(
                    systemImage: "timer",
                    title: "Nothing on the stove yet",
                    subtitle: "Track several dishes at once with quick presets and swipe controls."
                )
                Button {
                    FeedbackService.tap()
                    model.showingAdd = true
                } label: {
                    Text("New Timer")
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
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
            }
            .padding(.top, 72)
        }
    }
}

private struct TimerCard: View {
    let timer: DishTimerModel
    let now: Date
    let sceneActive: Bool
    let scalePulse: Bool
    let onStart: () -> Void
    let onPause: () -> Void
    let onReset: () -> Void
    let onComplete: () -> Void
    let onDelete: () -> Void

    @State private var completionFired = false

    private var remaining: Int {
        TimersViewModel.remaining(for: timer, now: now)
    }

    private var timeLabel: String {
        let r = sceneActive && timer.status == .running ? remaining : TimersViewModel.remaining(for: timer, now: now)
        let m = r / 60
        let s = r % 60
        return String(format: "%02d:%02d", m, s)
    }

    var body: some View {
        TimerDishCard(
            timer: timer,
            timeLabel: timeLabel,
            scalePulse: scalePulse,
            onStart: {
                completionFired = false
                onStart()
            },
            onPause: onPause,
            onReset: {
                completionFired = false
                onReset()
            }
        )
        .timerListCardSizing()
        .onChange(of: remaining) { newValue in
            guard timer.status == .running else { return }
            if newValue == 0, completionFired == false {
                completionFired = true
                onComplete()
            }
        }
        .onChange(of: timer.status) { newStatus in
            if newStatus == .running {
                completionFired = false
            }
        }
        .onAppear {
            if timer.status == .running, remaining == 0, completionFired == false {
                completionFired = true
                onComplete()
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            if timer.status == .running {
                Button {
                    onPause()
                } label: {
                    Label("Pause", systemImage: "pause.fill")
                }
                .tint(Color.appPrimary)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
