//
//  ListRowChrome.swift
//  162PlatesPalettes
//

import SwiftUI

/// Card-style container for list rows (rounded, subtle border, shadow).
struct ListRowChrome<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppDepth.cardFace)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AppDepth.cardEdge, lineWidth: 1)
            )
            .appShadowCard()
    }
}

extension View {
    func recipeListCardSizing() -> some View {
        listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }

    func groceryListCardSizing() -> some View {
        listRowInsets(EdgeInsets(top: 5, leading: 18, bottom: 5, trailing: 18))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }

    func timerListCardSizing() -> some View {
        listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}
