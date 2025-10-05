//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 04.10.2025.
//

import Foundation

protocol TrackerViewModelDelegate: AnyObject {
    func didUpdateData()
    func didChangeFilterState(isActive: Bool)
}

final class TrackerViewModel {
    private let categoryStore: TrackerCategoryStore
    private let trackerStore: TrackerStore
    private let recordStore: TrackerRecordStore
    
    private(set) var filteredCategories: [TrackerCategory] = []
    weak var delegate: TrackerViewModelDelegate?
    
    private var selectedDate: Date? {
        didSet {
            filterCategories()
            delegate?.didUpdateData()
        }
    }
    
    init(categoryStore: TrackerCategoryStore, trackerStore: TrackerStore, recordStore: TrackerRecordStore) {
        self.categoryStore = categoryStore
        self.trackerStore = trackerStore
        self.recordStore = recordStore
        self.trackerStore.delegate = self
    }
    
    func getDate() -> Date { selectedDate ?? Date() }
    func getCategoriesCount() -> Int { filteredCategories.count }
    func getTrackersCount(at section: Int) -> Int { filteredCategories[section].trackers.count }
    func getCategoryTitle(section: Int) -> String { filteredCategories[section].title }
    func getTracker(at indexPath: IndexPath) -> Tracker { filteredCategories[indexPath.section].trackers[indexPath.row] }
    
    func selectDate(_ value: Date = Date()) { selectedDate = value }
    
    func getRecordCount(at indexPath: IndexPath) -> Int {
        let tracker = getTracker(at: indexPath)
        return recordStore.getCount(for: tracker.id)
    }
    
    func isCompleted(at indexPath: IndexPath) -> Bool {
        let tracker = getTracker(at: indexPath)
        guard let selectedDate else { return false }
        return recordStore.hasRecord(for: tracker.id, on: selectedDate)
    }
    
    func toggleComplete(at indexPath: IndexPath) {
        guard let selectedDate, selectedDate <= Date() else { return }
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        if recordStore.hasRecord(for: tracker.id, on: selectedDate) {
            try? recordStore.removeRecord(for: tracker.id, on: selectedDate)
        } else {
            let record = TrackerRecord(id: tracker.id, date: selectedDate)
            try? recordStore.addRecord(record)
        }

        delegate?.didUpdateData()
    }
    
    func filterCategories() {
        guard let selectedWeekday = getWeekday() else { return }
        let categories = categoryStore.categories
        filteredCategories = categories.compactMap({
            let filteredTrackers = $0.trackers.filter({ $0.weekdays.contains(selectedWeekday) })
            if filteredTrackers.isEmpty { return nil }
            return TrackerCategory(title: $0.title, trackers: filteredTrackers)
        })
    }
    
    func getWeekday() -> Weekday? {
        guard let date = selectedDate else { return nil }
        let weekday = Calendar.current.component(.weekday, from: date)
        return Weekday.allCases[weekday - 1]
    }
    
    func addTracker(for category: TrackerCategory) throws {
        guard let tracker = category.trackers.first else { return }
        try self.trackerStore.addTracker(tracker, to: category.title)
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        let category = filteredCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        try? self.trackerStore.delete(tracker, from: category.title)
    }
    
    func updateTracker(to newCategory: TrackerCategory, from indexPath: IndexPath) throws {
        guard let tracker = newCategory.trackers.first else { return }
        let oldCategoryTitle = filteredCategories[indexPath.section].title
        try trackerStore.updateTracker(tracker, to: newCategory.title, from: oldCategoryTitle)
    }
    
    func updateSearchResults(for query: String?) {
        if let text = query, !text.isEmpty {
            filteredCategories = categoryStore.categories.compactMap({
                let filteredTrackers = $0.trackers.filter({ $0.title.lowercased().starts(with: text.lowercased()) })
                if filteredTrackers.isEmpty { return nil }
                return TrackerCategory(title: $0.title, trackers: filteredTrackers)
            })
        } else {
            filterCategories()
        }
        
        delegate?.didUpdateData()
    }
    
    func setFilter(_ filter: TrackerFilter) {
        switch filter {
        case .all, .forToday:
            selectedDate = Date()
            delegate?.didChangeFilterState(isActive: false)
        case .completed:
            fetchForCompletion(hasRecord: true)
        case .uncompleted:
            fetchForCompletion(hasRecord: false)
        }
    }
    
    private func fetchForCompletion(hasRecord: Bool) {
        filterCategories()
        
        guard let selectedDate else { return }
        filteredCategories = filteredCategories.compactMap { category in
            let completedTrackers = category.trackers.filter({
                recordStore.hasRecord(for: $0.id, on: selectedDate) == hasRecord
            })
            
            return completedTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: completedTrackers)
        }

        delegate?.didUpdateData()
        delegate?.didChangeFilterState(isActive: true)
    }
}

extension TrackerViewModel: TrackerStoreDelegate {
    func didInsertTracker(to categoryTitle: String) {
        filterCategories()
        delegate?.didUpdateData()
    }
    
    func didUpdateTracker() {
        filterCategories()
        delegate?.didUpdateData()
    }
    
    func didDeleteTracker() {
        filterCategories()
        delegate?.didUpdateData()
    }
}
