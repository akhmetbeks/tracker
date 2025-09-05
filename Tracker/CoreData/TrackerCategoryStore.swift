//
//  TrackerStore.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 05.09.2025.
//

import CoreData

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    
    private lazy var controller: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.id, ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: "category.title",
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
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        // TODO: Передавать в контроллер
        insertedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = indexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
}
