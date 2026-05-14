//
//  EmptyHero.swift
//  162PlatesPalettes
//

import SwiftUI

struct EmptyHero: View {
    let systemImage: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.appPrimary.opacity(0.5), Color.appSurface.opacity(0.15), Color.clear],
                            center: .center,
                            startRadius: 10,
                            endRadius: 72
                        )
                    )
                    .frame(width: 124, height: 124)
                Image(systemName: systemImage)
                    .font(.system(size: 52))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.appAccent, Color.appPrimary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .appShadowIconGlow()
            }
            Text(title)
                .font(.title3.weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appTextPrimary)
            Text(subtitle)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appTextSecondary)
                .padding(.horizontal, 8)
        }
        .padding(.vertical, 8)
    }
}
