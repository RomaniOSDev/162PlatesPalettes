//
//  OnboardingView.swift
//  162PlatesPalettes
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isComplete: Bool
    @State private var page = 0

    private let pages: [OnboardingPageModel] = [
        OnboardingPageModel(
            stepLabel: "Explore",
            headline: "Recipes that inspire",
            body: "Scroll a rich catalog, open any dish for ingredients and steps, and save favorites in one tap.",
            artwork: { OnboardingArtDiscover() }
        ),
        OnboardingPageModel(
            stepLabel: "Plan",
            headline: "Shop with clarity",
            body: "Group items by category, swipe to edit, and check things off as you move through the store.",
            artwork: { OnboardingArtPlan() }
        ),
        OnboardingPageModel(
            stepLabel: "Cook",
            headline: "Timers that keep up",
            body: "Stack several timers, pause when you need to, and reset without losing your place.",
            artwork: { OnboardingArtCook() }
        )
    ]

    var body: some View {
        ZStack {
            AppChromeBackground()
            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 4)

                TabView(selection: $page) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, model in
                        OnboardingSlideView(model: model, isActive: page == index)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                pageDots
                    .padding(.top, 10)
                    .padding(.bottom, 14)

                bottomActions
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)
            }
        }
    }

    private var topBar: some View {
        HStack(alignment: .center) {
            if page > 0 {
                Button {
                    FeedbackService.tap()
                    withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                        page -= 1
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.subheadline.weight(.semibold))
                        Text("Back")
                            .font(.subheadline.weight(.semibold))
                    }
                    .foregroundStyle(Color.appPrimary)
                }
                .buttonStyle(.plain)
            } else {
                Color.clear.frame(width: 72, height: 36)
            }

            Spacer(minLength: 0)

            Text("STEP \(page + 1) / \(pages.count)")
                .font(.caption2.weight(.bold))
                .tracking(1.2)
                .foregroundStyle(Color.appTextSecondary)

            Spacer(minLength: 0)

            Button {
                FeedbackService.tap()
                isComplete = true
            } label: {
                Text("Skip")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.appTextSecondary)
            }
            .buttonStyle(.plain)
            .frame(width: 72, alignment: .trailing)
        }
    }

    private var pageDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { idx in
                Group {
                    if idx == page {
                        Capsule()
                            .fill(AppDepth.primaryCTAGlow)
                    } else {
                        Capsule()
                            .fill(Color.appTextSecondary.opacity(0.2))
                    }
                }
                .frame(width: idx == page ? 28 : 8, height: 8)
                .overlay(
                    Capsule()
                        .stroke(Color.appTextPrimary.opacity(idx == page ? 0.12 : 0), lineWidth: 1)
                )
                .animation(.spring(response: 0.4, dampingFraction: 0.78), value: page)
                .accessibilityLabel("Page \(idx + 1) of \(pages.count)")
            }
        }
    }

    private var bottomActions: some View {
        Button {
            FeedbackService.medium()
            if page < pages.count - 1 {
                withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                    page += 1
                }
            } else {
                isComplete = true
            }
        } label: {
            HStack(spacing: 10) {
                Text(page == pages.count - 1 ? "Get Started" : "Continue")
                    .font(.headline.weight(.semibold))
                Image(systemName: page == pages.count - 1 ? "arrow.right.circle.fill" : "arrow.right")
                    .font(.title3.weight(.semibold))
            }
            .foregroundStyle(Color.appTextPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppDepth.primaryCTAGlow)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.appTextPrimary.opacity(0.18), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
            .appShadowPrimaryGlow()
        }
        .buttonStyle(OnboardingCTAButtonStyle())
    }
}

// MARK: - Models

private struct OnboardingPageModel {
    let stepLabel: String
    let headline: String
    let body: String
    let artwork: () -> AnyView

    init(stepLabel: String, headline: String, body: String, artwork: @escaping () -> some View) {
        self.stepLabel = stepLabel
        self.headline = headline
        self.body = body
        self.artwork = { AnyView(artwork()) }
    }
}

// MARK: - Slide (one card = one shadow)

private struct OnboardingSlideView: View {
    let model: OnboardingPageModel
    let isActive: Bool

    @State private var reveal = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            ListRowChrome {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .bottomLeading) {
                        model.artwork()
                            .frame(maxWidth: .infinity)
                            .frame(height: 220)
                            .clipped()

                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.55),
                                Color.black.opacity(0.12),
                                Color.clear
                            ],
                            startPoint: .bottom,
                            endPoint: .center
                        )
                        .frame(height: 220)

                        VStack(alignment: .leading, spacing: 6) {
                            Text(model.stepLabel.uppercased())
                                .font(.caption2.weight(.bold))
                                .tracking(1.4)
                                .foregroundStyle(Color.appAccent)
                            Text(model.headline)
                                .font(.title2.weight(.bold))
                                .foregroundStyle(Color.appTextPrimary)
                                .shadow(color: .black.opacity(0.35), radius: 6, y: 2)
                        }
                        .padding(18)
                    }

                    Rectangle()
                        .fill(Color.appTextSecondary.opacity(0.1))
                        .frame(height: 1)
                        .padding(.horizontal, 4)

                    Text(model.body)
                        .font(.body)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 4)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .scaleEffect(reveal ? 1 : 0.94)
            .opacity(reveal ? 1 : 0)
            .offset(y: reveal ? 0 : 12)
        }
        .onAppear {
            if isActive {
                playEntrance()
            }
        }
        .onChange(of: isActive) { active in
            if active {
                playEntrance()
            }
        }
    }

    private func playEntrance() {
        reveal = false
        withAnimation(.spring(response: 0.52, dampingFraction: 0.84).delay(0.04)) {
            reveal = true
        }
    }
}

// MARK: - CTA

private struct OnboardingCTAButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Art

private struct OnboardingArtDiscover: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.appBackground.opacity(0.9),
                    Color.appSurface.opacity(0.5),
                    Color.appPrimary.opacity(0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppDepth.cardFace.opacity(0.55))
                .frame(width: 118, height: 148)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AppDepth.cardEdge.opacity(0.5), lineWidth: 1)
                )
                .rotationEffect(.degrees(-8))
                .offset(x: -52, y: 18)

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppDepth.cardFace)
                .frame(width: 132, height: 158)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AppDepth.cardEdge, lineWidth: 1)
                )
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.appAccent.opacity(0.35))
                            .frame(height: 10)
                            .frame(maxWidth: .infinity)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.appTextSecondary.opacity(0.2))
                            .frame(height: 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 24)
                        Spacer(minLength: 0)
                        HStack {
                            Image(systemName: "clock.fill")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.appPrimary)
                            Text("32 min")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Color.appTextSecondary)
                        }
                    }
                    .padding(14)
                )
                .offset(x: 8, y: -6)

            Image(systemName: "heart.fill")
                .font(.title2)
                .foregroundStyle(Color.appAccent)
                .padding(10)
                .background(Circle().fill(Color.appSurface.opacity(0.9)))
                .overlay(Circle().stroke(Color.appAccent.opacity(0.35), lineWidth: 1))
                .offset(x: 72, y: -58)
        }
    }
}

private struct OnboardingArtPlan: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.appBackground.opacity(0.85),
                    Color.appPrimary.opacity(0.08),
                    Color.appAccent.opacity(0.1)
                ],
                startPoint: .top,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: "basket.fill")
                        .foregroundStyle(Color.appAccent)
                    Spacer()
                    Capsule()
                        .fill(Color.appPrimary.opacity(0.35))
                        .frame(width: 44, height: 22)
                }
                .font(.title3.weight(.semibold))
                .padding(.bottom, 16)

                OnboardingPlanLine(icon: "leaf.fill", title: "Produce", tint: Color.appPrimary, done: false)
                OnboardingPlanLine(icon: "archivebox.fill", title: "Pantry", tint: Color.appAccent, done: true)
                OnboardingPlanLine(icon: "cup.and.saucer.fill", title: "Dairy", tint: Color.appPrimary, done: false)
            }
            .padding(18)
            .frame(maxWidth: 280)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(AppDepth.cardFace.opacity(0.92))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(AppDepth.cardEdge.opacity(0.85), lineWidth: 1)
                    )
            )
        }
    }
}

private struct OnboardingPlanLine: View {
    let icon: String
    let title: String
    let tint: Color
    let done: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(tint)
                .frame(width: 32, height: 32)
                .background(RoundedRectangle(cornerRadius: 9).fill(tint.opacity(0.16)))
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.appTextPrimary)
            Spacer(minLength: 0)
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .font(.body.weight(.semibold))
                .foregroundStyle(done ? Color.appPrimary : Color.appTextSecondary.opacity(0.35))
        }
        .padding(.vertical, 8)
    }
}

private struct OnboardingArtCook: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.appBackground.opacity(0.9),
                    Color.appSurface.opacity(0.4),
                    Color.appPrimary.opacity(0.15)
                ],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )

            ZStack {
                ForEach(0..<3, id: \.self) { ring in
                    Circle()
                        .stroke(Color.appTextSecondary.opacity(0.06 + Double(ring) * 0.04), lineWidth: 2)
                        .frame(width: 100 + CGFloat(ring) * 36, height: 100 + CGFloat(ring) * 36)
                }

                Circle()
                    .trim(from: 0, to: 0.72)
                    .stroke(
                        AngularGradient(
                            colors: [Color.appPrimary, Color.appAccent, Color.appPrimary],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 9, lineCap: .round)
                    )
                    .frame(width: 132, height: 132)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 8) {
                    Image(systemName: "timer")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.appAccent, Color.appPrimary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Text("00:15")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(Color.appTextPrimary)
                    HStack(spacing: 8) {
                        Capsule()
                            .fill(Color.appPrimary.opacity(0.45))
                            .frame(width: 52, height: 8)
                        Capsule()
                            .fill(Color.appTextSecondary.opacity(0.2))
                            .frame(width: 36, height: 8)
                    }
                }
            }
        }
    }
}
