//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 04.09.2025.
//

import CoreData
import UIKit

final class CoreDataStack {
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: "TrackerModel")
        
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Ошибка при загрузке хранилища: \(error)")
            }
        })
    }
    
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
            }
        }
    }
}
