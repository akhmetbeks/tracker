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
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Ошибка при загрузке хранилища: \(error)")
            }
        }
    }
}
