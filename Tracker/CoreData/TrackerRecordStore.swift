//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Sultan Akhmetbek on 08.09.2025.
//

import CoreData

final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext
    
    override init() {
        let container = TrackerPersistentCoordinator.shared
        self.context = container.context
    }
    
    var records: [TrackerRecord] {
        do {
            let items = try context.fetch(TrackerRecordCoreData.fetchRequest())
            return items.compactMap({ $0.toModel() })
        } catch {
            return []
        }
    }
    
    func getCount(for trackerID: UUID) -> Int {
        let request = TrackerRecordCoreData.fetchRequest()
//        request.predicate = NSPredicate(format: "%K.%K == %@",
//            #keyPath(TrackerRecordCoreData.tracker), #keyPath(TrackerCoreData.id), trackerID as CVarArg)
//        return (try? context.count(for: request)) ?? 0
        
        return 0
    }
    
    func hasRecord(for trackerID: UUID, on date: Date) -> Bool {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return false
        }
        
        let request = TrackerRecordCoreData.fetchRequest()
        request.resultType = .countResultType
        
//        request.predicate = NSPredicate(
//            format: "%K.%K == %@ AND %K BETWEEN {%@, %@}",
//            #keyPath(TrackerRecordCoreData.tracker), #keyPath(TrackerCoreData.id), trackerID as CVarArg,
//            #keyPath(TrackerRecordCoreData.date), startOfDay as CVarArg, endOfDay as CVarArg
//        )
//
//        let count = (try? context.count(for: request)) ?? 0
//        
//        return count > 0
        
        return false
    }
    
    func addRecord(_ record: TrackerRecord) throws {
        let entity = TrackerRecordCoreData(context: context)
        entity.date = record.date
        
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", record.id as CVarArg)
        
        if let trackerEntity = try context.fetch(request).first {
            entity.tracker = trackerEntity
        }
        
        try context.save()
    }
    
    func removeRecord(for trackerID: UUID, on date: Date) throws {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@ AND %K >= %@ AND %K < %@",
            #keyPath(TrackerRecordCoreData.tracker), trackerID as CVarArg,
            #keyPath(TrackerRecordCoreData.date), startOfDay as CVarArg,
            #keyPath(TrackerRecordCoreData.date), endOfDay as CVarArg
        )
        
        if let record = try context.fetch(request).first {
            context.delete(record)
            try context.save()
        }
    }
}
