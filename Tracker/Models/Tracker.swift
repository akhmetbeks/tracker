//
//  Tracker.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 21.08.2025.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let weekdays: [Weekday]
}

extension Tracker {
    func colorLiteral() -> Data? { color.toData() }
}
