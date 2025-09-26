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
              let colorHex = self.colorHex,
              let emoji = self.emoji else { return nil }

        let color = color(from: colorHex)
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
    
    func color(from hex: String) -> UIColor {
        var rgbValue:UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension TrackerRecordCoreData {
    func toModel() -> TrackerRecord? {
        guard let id = tracker?.uuid, let date = date else { return nil }
        return TrackerRecord(id: id, date: date)
    }
}
