//
//  Weekdays.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 21.08.2025.
//

import Foundation

enum Weekday: Int, CaseIterable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

extension Weekday {
    func name(locale: Locale = .current, formatter: DateFormatter) -> String {
        formatter.locale = locale
        return formatter.weekdaySymbols[self.rawValue - 1]
    }

    func shortName(locale: Locale = .current, formatter: DateFormatter) -> String {
        formatter.locale = locale
        return formatter.shortWeekdaySymbols[self.rawValue - 1]
    }
}
