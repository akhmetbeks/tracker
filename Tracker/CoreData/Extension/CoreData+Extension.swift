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
        guard let id = self.uuid,
              let title = self.title,
              let colorLiteral = self.colorLiteral,
              let color = fromData(colorLiteral),
              let emoji = self.emoji else { return nil }

        
        let weekdaysRaw = self.weekdays as? [Int] ?? []
        let weekdays = weekdaysRaw.compactMap { Weekday(rawValue: $0) }

        return Tracker(
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            weekdays: weekdays
        )
    }
    
    func fromData(_ data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}

extension TrackerRecordCoreData {
    func toModel() -> TrackerRecord? {
        guard let id = tracker?.uuid, let date = date else { return nil }
        return TrackerRecord(id: id, date: date)
    }
}
