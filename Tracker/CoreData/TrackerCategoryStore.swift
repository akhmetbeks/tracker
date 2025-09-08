//
//  TrackerStore.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 05.09.2025.
//

import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didInsertSections(_ sections: IndexSet)
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private lazy var controller: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "title",
            cacheName: nil)
        
        controller.delegate = self
        try? controller.performFetch()
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

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange sectionInfo: any NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            delegate?.didInsertSections(IndexSet(integer: sectionIndex))
        default:
            break
        }
    }
}
