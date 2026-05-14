//
//  PlanCookHeader.swift
//  162PlatesPalettes
//

import SwiftUI

struct PlanCookHeader<Content: View>: View {
    private let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            content()
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppDepth.cardFace.opacity(0.92))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.appAccent.opacity(0.45), Color.appPrimary.opacity(0.18)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                )
                .appShadowSoft()
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.appBackground, Color.appSurface.opacity(0.42), Color.appSurface.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
