//
//  AppSearchBar.swift
//  162PlatesPalettes
//

import SwiftUI

struct AppSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search"

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.body.weight(.medium))
                .foregroundStyle(Color.appAccent)
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.words)
                .foregroundStyle(Color.appTextPrimary)
                .onTapGesture {
                    FeedbackService.tap()
                }
            if text.isEmpty == false {
                Button {
                    FeedbackService.tap()
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.body)
                        .foregroundStyle(Color.appTextSecondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppDepth.searchField)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.appAccent.opacity(0.32),
                                    Color.appPrimary.opacity(0.12)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .appShadowSoft()
    }
}
