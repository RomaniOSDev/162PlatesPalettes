//
//  DishTimerModel.swift
//  162PlatesPalettes
//

import Foundation

enum DishTimerStatus: String, Codable, Equatable {
    case idle
    case running
    case paused
    case completed
}

struct DishTimerModel: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var dishName: String
    /// Seconds remaining when paused or idle; ignored while running if fireDate is set.
    var remainingSeconds: Int
    var totalSeconds: Int
    var status: DishTimerStatus
    /// End time for active countdown while app is running (also persisted for resume).
    var fireDate: Date?

    init(
        id: UUID = UUID(),
        dishName: String,
        remainingSeconds: Int,
        totalSeconds: Int,
        status: DishTimerStatus = .idle,
        fireDate: Date? = nil
    ) {
        self.id = id
        self.dishName = dishName
        self.remainingSeconds = remainingSeconds
        self.totalSeconds = totalSeconds
        self.status = status
        self.fireDate = fireDate
    }
}
