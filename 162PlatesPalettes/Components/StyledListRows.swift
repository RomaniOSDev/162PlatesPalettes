//
//  StyledListRows.swift
//  162PlatesPalettes
//

import SwiftUI

// MARK: - Recipe

struct RecipeCardRow: View {
    let recipe: Recipe

    var body: some View {
        ListRowChrome {
            HStack(alignment: .center, spacing: 14) {
                RecipeThumbnailCanvas(recipeId: recipe.id)
                    .frame(width: 76, height: 76)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.appPrimary)
                        Text("\(recipe.cookTimeMinutes) min")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.appPrimary.opacity(0.28), Color.appPrimary.opacity(0.12)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title3)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.appTextSecondary, Color.appSurface.opacity(0.5))
            }
        }
    }
}

// MARK: - Grocery

struct GroceryItemCardRow: View {
    let item: GroceryItem
    let pulse: Bool
    let onToggle: () -> Void

    var body: some View {
        ListRowChrome {
            HStack(alignment: .top, spacing: 14) {
                Button(action: onToggle) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.appPrimary.opacity(item.completed ? 0.28 : 0.12))
                            .frame(width: 44, height: 44)
                        Image(systemName: item.completed ? "checkmark" : "circle")
                            .font(.body.weight(.bold))
                            .foregroundStyle(item.completed ? Color.appTextPrimary : Color.appTextSecondary)
                    }
                }
                .buttonStyle(.plain)
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.name)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                        .strikethrough(item.completed, color: Color.appTextSecondary)
                    if item.note.isEmpty == false {
                        Text(item.note)
                            .font(.footnote)
                            .foregroundStyle(Color.appTextSecondary)
                            .lineLimit(3)
                    }
                }
                Spacer(minLength: 0)
            }
        }
        .scaleEffect(pulse ? 1.03 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.78), value: pulse)
    }
}

struct GroceryCategoryPill: View {
    let title: String
    let count: Int
    let expanded: Bool
    let iconName: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.body.weight(.semibold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 28, height: 28)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.appAccent.opacity(0.15)))
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.appTextPrimary)
            Spacer(minLength: 0)
            Text("\(count)")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.appTextPrimary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color.appPrimary.opacity(0.35)))
            Image(systemName: expanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                .foregroundStyle(Color.appTextSecondary)
                .font(.title3)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppDepth.cardFace.opacity(0.92))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.appPrimary.opacity(0.22), lineWidth: 1)
                )
        )
        .appShadowSoft()
    }
}

extension GroceryCategory {
    var listIcon: String {
        switch self {
        case .produce: return "leaf.fill"
        case .dairy: return "cup.and.saucer.fill"
        case .pantry: return "archivebox.fill"
        case .meat: return "fish.fill"
        case .bakery: return "birthday.cake.fill"
        case .frozen: return "snowflake"
        case .other: return "basket.fill"
        }
    }
}

// MARK: - Timer

struct TimerDishCard: View {
    let timer: DishTimerModel
    let timeLabel: String
    let scalePulse: Bool
    let onStart: () -> Void
    let onPause: () -> Void
    let onReset: () -> Void

    var body: some View {
        ListRowChrome {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(timer.dishName)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(Color.appTextPrimary)
                        statusPill
                    }
                    Spacer(minLength: 0)
                    Text(timeLabel)
                        .monospacedDigit()
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.appAccent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.appBackground.opacity(0.55))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.appAccent.opacity(0.45), lineWidth: 1)
                                )
                        )
                }
                HStack(spacing: 10) {
                    if timer.status == .running {
                        Button("Pause", action: onPause)
                            .buttonStyle(TimerPillButtonStyle(filled: true))
                    } else if timer.status != .completed {
                        Button("Start", action: onStart)
                            .buttonStyle(TimerPillButtonStyle(filled: true))
                    }
                    Button("Reset", action: onReset)
                        .buttonStyle(TimerPillButtonStyle(filled: false))
                    Spacer(minLength: 0)
                }
            }
        }
        .scaleEffect(scalePulse ? 1.04 : 1)
        .animation(.spring(response: 0.35, dampingFraction: 0.72), value: scalePulse)
    }

    @ViewBuilder
    private var statusPill: some View {
        let tuple: (String, Color, Color) = {
            switch timer.status {
            case .running:
                return ("Running", Color.appTextPrimary, Color.appPrimary.opacity(0.3))
            case .paused:
                return ("Paused", Color.appTextPrimary, Color.appTextSecondary.opacity(0.25))
            case .completed:
                return ("Done", Color.appPrimary, Color.appPrimary.opacity(0.2))
            case .idle:
                return ("Ready", Color.appTextSecondary, Color.appSurface.opacity(0.6))
            }
        }()
        Text(tuple.0)
            .font(.caption.weight(.bold))
            .foregroundStyle(tuple.1)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Capsule().fill(tuple.2))
    }
}

private struct TimerPillButtonStyle: ButtonStyle {
    let filled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.bold))
            .foregroundStyle(Color.appTextPrimary)
            .padding(.horizontal, 18)
            .padding(.vertical, 11)
            .background(
                Group {
                    if filled {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.appPrimary)
                    } else {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.appAccent, lineWidth: 1.5)
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
