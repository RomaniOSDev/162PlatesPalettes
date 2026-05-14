//
//  PlanCookContainerView.swift
//  162PlatesPalettes
//

import SwiftUI

private enum PlanCookSegment: String, CaseIterable, Identifiable {
    case groceries = "Groceries"
    case timers = "Cooking Timers"

    var id: String { rawValue }
}

struct PlanCookContainerView: View {
    @State private var segment: PlanCookSegment = .groceries

    var body: some View {
        VStack(spacing: 0) {
            PlanCookHeader {
                Picker("Section", selection: $segment) {
                    ForEach(PlanCookSegment.allCases) { seg in
                        Text(seg.rawValue).tag(seg)
                    }
                }
                .pickerStyle(.segmented)
                .tint(Color.appPrimary)
                .onChange(of: segment) { _ in
                    FeedbackService.tap()
                }
            }

            Group {
                switch segment {
                case .groceries:
                    GroceryView()
                case .timers:
                    TimersView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onReceive(NotificationCenter.default.publisher(for: .planCookOpenSegment)) { output in
            guard let raw = output.userInfo?[PlanCookSegmentKey.segment] as? String else { return }
            if raw == PlanCookSegmentValue.timers {
                segment = .timers
            } else if raw == PlanCookSegmentValue.groceries {
                segment = .groceries
            }
        }
    }
}
