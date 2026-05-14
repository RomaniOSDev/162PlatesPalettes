//
//  AppDepth.swift
//  162PlatesPalettes
//
//  Shared depth, gradients, and shadows. Keep radii modest and one shadow per
//  floating layer to reduce offscreen rendering and scroll jank.
//

import SwiftUI

enum AppDepth {
    // MARK: Shadows

    static let cardOpacity: Double = 0.18
    static let cardRadius: CGFloat = 8
    static let cardY: CGFloat = 4

    static let softOpacity: Double = 0.12
    static let softRadius: CGFloat = 6
    static let softY: CGFloat = 3

    static let barOpacity: Double = 0.2
    static let barRadius: CGFloat = 10
    static let barY: CGFloat = -3

    static let glowPrimaryOpacity: Double = 0.28
    static let glowPrimaryRadius: CGFloat = 10
    static let glowPrimaryY: CGFloat = 4

    static let iconGlowOpacity: Double = 0.22
    static let iconGlowRadius: CGFloat = 7
    static let iconGlowY: CGFloat = 3

    // MARK: Gradients (value types — cheap to pass around)

    static var screenMesh: LinearGradient {
        LinearGradient(
            colors: [
                Color.appBackground,
                Color.appSurface.opacity(0.42),
                Color.appBackground.opacity(0.96)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var cardFace: LinearGradient {
        LinearGradient(
            colors: [
                Color.appSurface.opacity(0.99),
                Color.appSurface.opacity(0.78)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var cardEdge: LinearGradient {
        LinearGradient(
            colors: [
                Color.appAccent.opacity(0.38),
                Color.appPrimary.opacity(0.16)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var tabBarSurface: LinearGradient {
        LinearGradient(
            colors: [
                Color.appSurface.opacity(0.98),
                Color.appSurface.opacity(0.82),
                Color.appBackground.opacity(0.55)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var tabSelected: LinearGradient {
        LinearGradient(
            colors: [
                Color.appPrimary.opacity(0.95),
                Color.appPrimary.opacity(0.72)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var searchField: LinearGradient {
        LinearGradient(
            colors: [
                Color.appSurface.opacity(0.94),
                Color.appSurface.opacity(0.72)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var primaryCTAGlow: LinearGradient {
        LinearGradient(
            colors: [
                Color.appPrimary.opacity(0.95),
                Color.appPrimary.opacity(0.78)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var chipSelected: LinearGradient {
        LinearGradient(
            colors: [
                Color.appPrimary.opacity(0.55),
                Color.appPrimary.opacity(0.38)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var bannerToast: LinearGradient {
        LinearGradient(
            colors: [
                Color.appSurface.opacity(0.97),
                Color.appSurface.opacity(0.82)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

extension View {
    func appShadowCard() -> some View {
        shadow(
            color: .black.opacity(AppDepth.cardOpacity),
            radius: AppDepth.cardRadius,
            x: 0,
            y: AppDepth.cardY
        )
    }

    func appShadowSoft() -> some View {
        shadow(
            color: .black.opacity(AppDepth.softOpacity),
            radius: AppDepth.softRadius,
            x: 0,
            y: AppDepth.softY
        )
    }

    func appShadowTabBar() -> some View {
        shadow(
            color: .black.opacity(AppDepth.barOpacity),
            radius: AppDepth.barRadius,
            x: 0,
            y: AppDepth.barY
        )
    }

    func appShadowPrimaryGlow() -> some View {
        shadow(
            color: Color.appPrimary.opacity(AppDepth.glowPrimaryOpacity),
            radius: AppDepth.glowPrimaryRadius,
            x: 0,
            y: AppDepth.glowPrimaryY
        )
    }

    func appShadowIconGlow() -> some View {
        shadow(
            color: Color.appPrimary.opacity(AppDepth.iconGlowOpacity),
            radius: AppDepth.iconGlowRadius,
            x: 0,
            y: AppDepth.iconGlowY
        )
    }
}
