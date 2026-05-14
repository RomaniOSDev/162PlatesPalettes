//
//  AppChromeBackground.swift
//  162PlatesPalettes
//

import SwiftUI

/// Full-screen backdrop: layered gradients only (no Canvas — cheaper while scrolling).
struct AppChromeBackground: View {
    var body: some View {
        ZStack {
            AppDepth.screenMesh

            // Soft light pools — fixed layout, no Blur, no GeometryReader
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.appAccent.opacity(0.14), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 160
                    )
                )
                .frame(width: 300, height: 300)
                .offset(x: 130, y: -120)
                .allowsHitTesting(false)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.appPrimary.opacity(0.11), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 180
                    )
                )
                .frame(width: 360, height: 360)
                .offset(x: -140, y: 220)
                .allowsHitTesting(false)
        }
        .ignoresSafeArea()
    }
}
