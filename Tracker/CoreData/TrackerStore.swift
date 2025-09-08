//
//  TrackerStore.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 07.09.2025.
//

import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func didInsertTracker(to categoryTitle: String)
}

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    weak var delegate: TrackerStoreDelegate?
    
    override init() {
        let coordinator = TrackerPersistentCoordinator.shared
        self.context = coordinator.context
        
        super.init()
    }
    
    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", categoryTitle)
        
        guard let categoryEntity = try context.fetch(request).first else { return }
        
        let trackerEntity = getTrackerCoreData(tracker, for: categoryEntity)
        categoryEntity.addToTracker(trackerEntity)
        
        try context.save()
        
        delegate?.didInsertTracker(to: categoryTitle)
    }
    
    private func getTrackerCoreData(_ tracker: Tracker, for category: TrackerCategoryCoreData) -> TrackerCoreData {
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.title = tracker.title
        trackerEntity.colorHex = tracker.hexString()
        trackerEntity.emoji = tracker.emoji
        trackerEntity.weekdays = tracker.weekdays.map { $0.rawValue } as NSObject
        trackerEntity.category = category
        return trackerEntity
    }
}
