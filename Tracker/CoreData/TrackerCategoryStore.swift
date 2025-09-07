//
//  TrackerStore.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 05.09.2025.
//

import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateCategories(_ items: [TrackerCategory])
    func didInsertSections(_ sections: IndexSet)
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private var insertedIndexes: [IndexPath]?
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private lazy var controller: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
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
    
    func fetchCategories() {
        guard let items = controller.fetchedObjects else { return }
        
        let categories = items.compactMap { $0.toModel() }
        
        delegate?.didUpdateCategories(categories)
    }
    
    func addCategory(_ item: TrackerCategory) throws {
        let category = TrackerCategoryCoreData(context: context)
        category.title = item.title
        
        let trackers = item.trackers.map { tracker in
            return getTrackerCoreData(tracker, for: category, context: context)
        }
        
        category.tracker = NSSet(array: trackers)
        
        try context.save()
    }
    
    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", categoryTitle)
        
        guard let categoryEntity = try context.fetch(request).first else { return }
        
        let trackerEntity = getTrackerCoreData(tracker, for: categoryEntity, context: context)
        categoryEntity.addToTracker(trackerEntity)
        
        try context.save()
    }
    
    private func getTrackerCoreData(_ tracker: Tracker, for category: TrackerCategoryCoreData, context: NSManagedObjectContext) -> TrackerCoreData {
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.title = tracker.title
        trackerEntity.colorHex = UIColorMarshalling().hexString(from: tracker.color)
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
