//
//  TrackerStore.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 05.09.2025.
//

import CoreData

final class TrackerCategoryStore: NSObject, NSFetchedResultsControllerDelegate {
    private let context: NSManagedObjectContext
    
    private lazy var controller: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "title",
            cacheName: nil)
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            print("Ошибка при инициализации NSFetchedResultsController: \(error.localizedDescription)")
        }
        
        return controller
    }()
    
    override init() {
        let coordinator = TrackerPersistentCoordinator.shared
        self.context = coordinator.context
        
        super.init()
    }
    
    var categories: [TrackerCategory] {
        guard let items = controller.fetchedObjects else { return [] }
        return items.compactMap { $0.toModel() }
    }
    
    func addCategory(_ item: TrackerCategory) throws {
        let category = TrackerCategoryCoreData(context: context)
        category.title = item.title
        
        let trackers = item.trackers.map { tracker in
            return getTrackerCoreData(tracker, for: category)
        }
        
        category.tracker = NSSet(array: trackers)
        
        try context.save()
        try controller.performFetch()
    }
    
    private func getTrackerCoreData(_ tracker: Tracker, for category: TrackerCategoryCoreData) -> TrackerCoreData {
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.uuid = tracker.id
        trackerEntity.title = tracker.title
        trackerEntity.colorHex = tracker.hexString()
        trackerEntity.emoji = tracker.emoji
        trackerEntity.weekdays = tracker.weekdays.map { $0.rawValue } as NSObject
        trackerEntity.category = category
        return trackerEntity
    }
}
