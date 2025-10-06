//
//  TrackerStore.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 07.09.2025.
//

import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func didInsertTracker(to categoryTitle: String)
    func didUpdateTracker()
    func didDeleteTracker()
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
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), categoryTitle)
        guard let categoryEntity = try context.fetch(request).first else { return }
        
        let trackerEntity = getTrackerCoreData(tracker, for: categoryEntity)
        categoryEntity.addToTracker(trackerEntity)
        
        try context.save()
        delegate?.didInsertTracker(to: categoryTitle)
    }
    
    func updateTracker(_ tracker: Tracker, to categoryTitle: String, from oldCategoryTitle: String?) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), categoryTitle)
        guard let categoryEntity = try context.fetch(request).first else { return }
        
        let trackerRequest = TrackerCoreData.fetchRequest()
        trackerRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.uuid), tracker.id as CVarArg)
        guard let trackerEntity = try context.fetch(trackerRequest).first else { return }
        
        trackerEntity.title = tracker.title
        trackerEntity.colorLiteral = tracker.colorLiteral()
        trackerEntity.emoji = tracker.emoji
        trackerEntity.weekdays = tracker.weekdays.map { $0.rawValue } as NSObject
        trackerEntity.category = categoryEntity
        try context.save()
        delegate?.didUpdateTracker()
    }
    
    func delete(_ tracker: Tracker, from categoryTitle: String) throws {
        let categoryRequest = TrackerCategoryCoreData.fetchRequest()
        categoryRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), categoryTitle)
        guard let categoryEntity = try context.fetch(categoryRequest).first else { return }

        let trackerRequest = TrackerCoreData.fetchRequest()
        trackerRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.uuid), tracker.id as CVarArg)
          
        do {
            if let trackerEntity = try context.fetch(trackerRequest).first {
                context.delete(trackerEntity)
                categoryEntity.removeFromTracker(trackerEntity)
                do {
                    try context.save()
                    delegate?.didDeleteTracker()
                } catch {
                    print(error.localizedDescription)
                }
            }
        } catch {
            print("FETCH DELETE: \(error.localizedDescription)")
        }
    }
    
    private func getTrackerCoreData(_ tracker: Tracker, for category: TrackerCategoryCoreData) -> TrackerCoreData {
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.uuid = tracker.id
        trackerEntity.title = tracker.title
        trackerEntity.colorLiteral = tracker.colorLiteral()
        trackerEntity.emoji = tracker.emoji
        trackerEntity.weekdays = tracker.weekdays.map { $0.rawValue } as NSObject
        trackerEntity.category = category
        return trackerEntity
    }
}
