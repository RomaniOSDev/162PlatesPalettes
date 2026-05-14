//
//  AchievementBus.swift
//  162PlatesPalettes
//

import Combine

enum AchievementBus {
    static let unlocked = PassthroughSubject<[String], Never>()
}
