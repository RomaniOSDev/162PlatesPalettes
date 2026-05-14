//
//  NotificationName+App.swift
//  162PlatesPalettes
//

import Foundation

extension Notification.Name {
    static let dataReset = Notification.Name("platePalette.dataReset")
    /// Switch Plan tab segment before or after navigating to Plan.
    static let planCookOpenSegment = Notification.Name("platePalette.planCookOpenSegment")
}

enum PlanCookSegmentKey {
    static let segment = "segment"
}

enum PlanCookSegmentValue {
    static let groceries = "groceries"
    static let timers = "timers"
}
