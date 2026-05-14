//
//  RecipeThumbnailCanvas.swift
//  162PlatesPalettes
//

import SwiftUI

struct RecipeThumbnailCanvas: View {
    let recipeId: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.appSurface)
            Group {
                switch recipeId {
                case "r1":
                    RoastChickenThumb()
                case "r2":
                    SoupThumb()
                case "r3":
                    SaladThumb()
                default:
                    GenericPlateThumb(seed: recipeId)
                }
            }
            .padding(12)
        }
        .frame(width: 72, height: 72)
    }
}

private struct RoastChickenThumb: View {
    var body: some View {
        ZStack {
            Circle().fill(Color.appPrimary.opacity(0.35))
            Image(systemName: "leaf.fill")
                .foregroundStyle(Color.appAccent)
        }
    }
}

private struct SoupThumb: View {
    var body: some View {
        ZStack {
            Ellipse().fill(Color.appAccent.opacity(0.35))
            Image(systemName: "drop.fill")
                .foregroundStyle(Color.appPrimary)
        }
    }
}

private struct SaladThumb: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8).fill(Color.appPrimary.opacity(0.25))
            Image(systemName: "leaf.circle.fill")
                .foregroundStyle(Color.appAccent)
        }
    }
}

private struct GenericPlateThumb: View {
    let seed: String
    var body: some View {
        let hue = Double(abs(seed.hashValue % 360)) / 360.0
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.appAccent.opacity(0.25))
            Image(systemName: "fork.knife.circle.fill")
                .foregroundStyle(Color.appPrimary)
                .hueRotation(.degrees(hue * 40))
        }
    }
}
