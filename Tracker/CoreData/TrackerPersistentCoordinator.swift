//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 04.09.2025.
//

import CoreData
import UIKit

final class TrackerPersistentCoordinator {
    static let shared = TrackerPersistentCoordinator()
    
    private let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Ошибка при загрузке хранилища: \(error)")
            }
        }
        
        context = container.newBackgroundContext()
    }
    
    private func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}
