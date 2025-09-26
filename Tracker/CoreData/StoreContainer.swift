//
//  StoreContainer.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 27.09.2025.
//

final class StoreContainer {
    let categoryStore: TrackerCategoryStore
    let trackerStore: TrackerStore
    let recordStore: TrackerRecordStore
    
    init() {
        self.categoryStore = TrackerCategoryStore()
        self.trackerStore = TrackerStore()
        self.recordStore = TrackerRecordStore()
    }
}
