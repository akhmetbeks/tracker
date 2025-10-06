//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 05.10.2025.
//

import Foundation

protocol StatisticsViewDelegate: AnyObject {
    func didUpdateData()
}

final class StatisticsViewModel {
    private(set) var statistics: [ StatisticsEnum: String ] = [:]
    
    private let recordStore: TrackerRecordStore
    private let calendar = Calendar.current
    
    weak var delegate: StatisticsViewDelegate?
    
    init(recordStore: TrackerRecordStore) {
        self.recordStore = recordStore
        self.recordStore.delegate = self
    }
    
    func loadStatistics() {
        let records = recordStore.records
        
        guard !records.isEmpty else {
            statistics = [:]
            delegate?.didUpdateData()
            return
        }
        
        let uniqueDays = Set(records.map { calendar.startOfDay(for: $0.date) })
        let totalActiveDays = uniqueDays.count
        
        let groupedByDay = Dictionary(grouping: records, by: { calendar.startOfDay(for: $0.date) })
        let bestDay = groupedByDay.max(by: { $0.value.count < $1.value.count })
        let bestDayFormatted = bestDay?.key.formatted(date: .abbreviated, time: .omitted) ?? "–"
        
        let average = Double(records.count) / Double(totalActiveDays)
        let averageFormatted = String(format: "%.1f", average)
        let totalCompleted = records.count
        
        statistics = [
            StatisticsEnum.totalCompleted : "\(totalCompleted)",
            StatisticsEnum.totalActiveDays : "\(totalActiveDays)",
            StatisticsEnum.bestDay : bestDayFormatted,
            StatisticsEnum.average : averageFormatted
        ]
        
        delegate?.didUpdateData()
    }
}

extension StatisticsViewModel: TrackerRecordStoreDelegate {
    func didUpdateRecords() {
        loadStatistics()
    }
}
