//
//  AchievementBannerHost.swift
//  162PlatesPalettes
//

import Combine
import SwiftUI

struct AchievementBannerHost: View {
    @State private var queue: [String] = []
    @State private var visibleTitle: String?

    var body: some View {
        VStack {
            if let title = visibleTitle {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.appAccent, Color.appPrimary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppDepth.bannerToast)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.appAccent.opacity(0.28), lineWidth: 1)
                )
                .appShadowCard()
                .padding(.horizontal, 12)
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            Spacer()
        }
        .allowsHitTesting(false)
        .onReceive(AchievementBus.unlocked.receive(on: DispatchQueue.main)) { ids in
            enqueue(ids.compactMap { id in
                AchievementDisplay.all.first { $0.id == id }?.title
            })
        }
    }

    private func enqueue(_ titles: [String]) {
        for t in titles where queue.contains(t) == false {
            queue.append(t)
        }
        pump()
    }

    private func pump() {
        guard visibleTitle == nil, queue.isEmpty == false else { return }
        let next = queue.removeFirst()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            visibleTitle = next
        }
        FeedbackService.achievementUnlocked()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.35)) {
                visibleTitle = nil
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                pump()
            }
        }
    }
}
