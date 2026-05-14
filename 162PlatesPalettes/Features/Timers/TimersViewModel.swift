//
//  TimersViewModel.swift
//  162PlatesPalettes
//

import AudioToolbox
import Combine
import Foundation
import SwiftUI
import UIKit

@MainActor
final class TimersViewModel: ObservableObject {
    @Published var showingAdd = false
    @Published var scalePulseId: UUID?

    static func remaining(for timer: DishTimerModel, now: Date) -> Int {
        if timer.status == .running, let end = timer.fireDate {
            return max(0, Int(ceil(end.timeIntervalSince(now))))
        }
        return timer.remainingSeconds
    }

    func start(_ timer: DishTimerModel, store: AppDataStore, now: Date) {
        FeedbackService.medium()
        let sec = max(1, Self.remaining(for: timer, now: now))
        var next = store.dishTimers
        guard let i = next.firstIndex(where: { $0.id == timer.id }) else { return }
        next[i].status = .running
        next[i].remainingSeconds = sec
        next[i].fireDate = now.addingTimeInterval(TimeInterval(sec))
        store.replaceDishTimers(next)
    }

    func pause(_ timer: DishTimerModel, store: AppDataStore, now: Date) {
        FeedbackService.tap()
        var next = store.dishTimers
        guard let i = next.firstIndex(where: { $0.id == timer.id }) else { return }
        if next[i].status == .running, let end = next[i].fireDate {
            next[i].remainingSeconds = max(0, Int(ceil(end.timeIntervalSince(now))))
        }
        next[i].fireDate = nil
        next[i].status = .paused
        store.replaceDishTimers(next)
    }

    func reset(_ timer: DishTimerModel, store: AppDataStore) {
        FeedbackService.tap()
        var next = store.dishTimers
        guard let i = next.firstIndex(where: { $0.id == timer.id }) else { return }
        next[i].fireDate = nil
        next[i].remainingSeconds = next[i].totalSeconds
        next[i].status = .idle
        store.replaceDishTimers(next)
    }

    func delete(id: UUID, store: AppDataStore) {
        FeedbackService.tap()
        var next = store.dishTimers
        next.removeAll { $0.id == id }
        store.replaceDishTimers(next)
    }

    func complete(timer: DishTimerModel, store: AppDataStore) {
        let minutes = max(1, Int(ceil(Double(timer.totalSeconds) / 60.0)))
        var next = store.dishTimers
        if let i = next.firstIndex(where: { $0.id == timer.id }) {
            next[i].status = .completed
            next[i].remainingSeconds = 0
            next[i].fireDate = nil
            store.replaceDishTimers(next)
        }
        _ = store.incrementTimersFinished(minutesRounded: minutes)
        if store.timerSoundEnabled {
            FeedbackService.timerCompleteHeavy()
            AudioServicesPlaySystemSound(1057)
        } else {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        scalePulseId = timer.id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.scalePulseId = nil
        }
    }
}
