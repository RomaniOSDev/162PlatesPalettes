//
//  AddTimerSheet.swift
//  162PlatesPalettes
//

import SwiftUI

struct AddTimerSheet: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.dismiss) private var dismiss

    @State private var dishName: String = ""
    @State private var minutes: Int = 15
    @State private var showError = false
    @State private var shakeAmount: CGFloat = 0
    private let durationPresets = [5, 10, 15, 20, 30, 45, 60, 90, 120]

    var body: some View {
        NavigationStack {
            ZStack {
                AppChromeBackground()
                Form {
                    Section {
                        TextField("Dish name", text: $dishName)
                            .foregroundStyle(Color.appTextPrimary)
                            .modifier(TimerFieldShake(amount: shakeAmount))
                        if showError {
                            Text("Enter a dish name.")
                                .font(.footnote)
                                .foregroundStyle(.red)
                        }
                    }
                    Section {
                        Stepper(value: $minutes, in: 1...180, step: 1) {
                            Text("Duration: \(minutes) min")
                                .foregroundStyle(Color.appTextPrimary)
                        }
                        .tint(Color.appPrimary)
                    } header: {
                        Text("Duration")
                            .foregroundStyle(Color.appTextSecondary)
                    }

                    Section {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 72), spacing: 8)], spacing: 8) {
                            ForEach(durationPresets, id: \.self) { m in
                                Button {
                                    FeedbackService.tap()
                                    minutes = m
                                } label: {
                                    Text("\(m)m")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(minutes == m ? Color.appTextPrimary : Color.appTextSecondary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(
                                            Group {
                                                if minutes == m {
                                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                        .fill(AppDepth.chipSelected)
                                                } else {
                                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                        .fill(AppDepth.cardFace.opacity(0.9))
                                                }
                                            }
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .stroke(
                                                        minutes == m ? Color.appAccent.opacity(0.35) : Color.appTextSecondary.opacity(0.12),
                                                        lineWidth: 1
                                                    )
                                            )
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    } header: {
                        Text("Quick presets")
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    Section {
                        Toggle("Sound when finished", isOn: Binding(
                            get: { store.timerSoundEnabled },
                            set: { store.setTimerSoundEnabled($0) }
                        ))
                        .tint(Color.appPrimary)
                        .foregroundStyle(Color.appTextPrimary)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("New Timer")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        FeedbackService.tap()
                        dismiss()
                    }
                    .foregroundStyle(Color.appPrimary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        save()
                    }
                    .foregroundStyle(Color.appPrimary)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func save() {
        let trimmed = dishName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            FeedbackService.warning()
            showError = true
            withAnimation(.easeInOut(duration: 0.12)) {
                shakeAmount += 1
            }
            return
        }
        FeedbackService.medium()
        FeedbackService.success()
        let seconds = max(60, minutes * 60)
        let model = DishTimerModel(
            dishName: trimmed,
            remainingSeconds: seconds,
            totalSeconds: seconds,
            status: .idle
        )
        store.addDishTimer(model)
        dismiss()
    }
}

private struct TimerFieldShake: ViewModifier {
    let amount: CGFloat
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .modifier(FieldShakeGeometry(shakes: phase))
            .onChange(of: amount) { _ in
                withAnimation(.easeInOut(duration: 0.08)) {
                    phase = 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    phase = 0
                }
            }
    }
}

private struct FieldShakeGeometry: GeometryEffect {
    var shakes: CGFloat

    var animatableData: CGFloat {
        get { shakes }
        set { shakes = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: 8 * sin(shakes * .pi * 3), y: 0))
    }
}
