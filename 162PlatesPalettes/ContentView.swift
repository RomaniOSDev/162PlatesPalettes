//
//  ContentView.swift
//  162PlatesPalettes
//
//  Created by Roman on 5/14/26.
//

import AudioToolbox
import Combine
import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var store = AppDataStore()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack(alignment: .top) {
            Group {
                if store.hasSeenOnboarding == false {
                    OnboardingView(
                        isComplete: Binding(
                            get: { store.hasSeenOnboarding },
                            set: { store.setHasSeenOnboarding($0) }
                        )
                    )
                } else {
                    MainTabShell()
                        .environmentObject(store)
                }
            }

            if store.hasSeenOnboarding {
                AchievementBannerHost()
                    .zIndex(2)
            }
        }
        .preferredColorScheme(.dark)
        .tint(Color.appPrimary)
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                celebrateReconciledTimers()
            } else {
                store.pauseRunningTimersForBackground()
            }
        }
        .onAppear {
            celebrateReconciledTimers()
        }
    }

    private func celebrateReconciledTimers() {
        let ids = store.reconcileTimersAfterForeground()
        guard ids.isEmpty == false else { return }
        for _ in ids {
            if store.timerSoundEnabled {
                FeedbackService.timerCompleteHeavy()
                AudioServicesPlaySystemSound(1057)
            } else {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}

#Preview {
    ContentView()
}
