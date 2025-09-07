//
//  TrackerCoreData+Extension.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 07.09.2025.
//

import UIKit

extension TrackerCategoryCoreData {
    func toModel() -> TrackerCategory? {
        guard let title = self.title,
              let trackerSet = self.tracker as? Set<TrackerCoreData> else { return nil }

        let trackers = trackerSet.compactMap { $0.toModel() }
        return TrackerCategory(title: title, trackers: trackers)
    }
}

extension TrackerCoreData {
    func toModel() -> Tracker? {
        guard let id = self.id,
              let title = self.title,
              let colorHex = self.colorHex,
              let emoji = self.emoji else { return nil }

        let color = UIColorMarshalling().color(from: colorHex)
        let weekdaysRaw = self.weekdays as? [String] ?? []
        let weekdays = weekdaysRaw.compactMap { WeekdaysEnum(rawValue: $0) }

        return Tracker(
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            weekdays: weekdays
        )
    }
}
