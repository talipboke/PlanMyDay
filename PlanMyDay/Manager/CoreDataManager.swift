//
//  CoreDataManager.swift
//  PlanMyDay
//
//  Created by Talip on 27.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import UIKit
import CoreData


protocol CoreDataProtocol{
    func fetch<M : NSManagedObject>(dbEntity : M.Type) -> [M]
    func delete(by objectID: NSManagedObjectID)
    func insert<M : NSManagedObject>(type : M.Type , changeOnObject : (M)->())
}

class CoreDataManager : CoreDataProtocol{
  
    
    //TODO : Hangisini kullanmak daha mantıklı? Aynı zamanda weak'e döndürülecek.
    
    //private(set) weak var context : NSManagedObjectContext?
    private let context : NSManagedObjectContext
    
    init(context : NSManagedObjectContext ) {
        self.context = context
    }
    
    func fetch<M : NSManagedObject>(dbEntity : M.Type) -> [M]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: dbEntity.description())

        var result = [M]()

        do {
            // Execute Fetch Request
            let records = try context.fetch(fetchRequest)

            if let records = records as? [M] {
                result = records
            }

        } catch {
            print("Unable to fetch managed objects for entity \(dbEntity.className).")
        }

        return result
    }

    
    func insert<M : NSManagedObject>(type : M.Type , changeOnObject : (M)->()){
        
        let newObject = M(context: context)
        changeOnObject(newObject)
        try? context.save()
    }
    
    func delete(by objectID: NSManagedObjectID) {

        // TODO : Error handling ' i yazılacak.
        
        let managedObject = context.object(with: objectID)
        context.delete(managedObject)
        try? context.save()
    
    }
    
    func update<M : NSManagedObject>(newObject : M.Type , MOid : NSManagedObjectID , changeOnObject : (M?)->()){
        
        let managedObject = context.object(with: MOid) as? M
        changeOnObject(managedObject)
        try? context.save()
    }
}

//extension NSManagedObjectContext{
//    func fetchObjects <T: NSManagedObject>(_ entityClass:T.Type,
//                                           sortBy: [NSSortDescriptor]? = nil,
//                                           predicate: NSPredicate? = nil) throws -> [T] {
//
//        let request: NSFetchRequest<T>
//        if #available(iOS 10.0, *) {
//            request = entityClass.fetchRequest() as! NSFetchRequest<T>
//        } else {
//            let entityName = String(describing: entityClass)
//            request = NSFetchRequest(entityName: entityName)
//        }
//
//        request.returnsObjectsAsFaults = false
//        request.predicate = predicate
//        request.sortDescriptors = sortBy
//
//        let fetchedResult = try self.fetch(request)
//        return fetchedResult
//    }
//}
