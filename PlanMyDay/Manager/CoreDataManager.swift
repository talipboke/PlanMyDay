//
//  CoreDataManager.swift
//  PlanMyDay
//
//  Created by Talip on 27.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import UIKit
import CoreData


class CoreDataManager{
 
    
    public static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    class func fetch<M : NSManagedObject>(dbEntity : M.Type) -> [M]{
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
    
    class func delete(by objectID: NSManagedObjectID) {
        
        let managedObject = context.object(with: objectID)
        context.delete(managedObject)
        try? context.save()
    }
    
    //Doğru çalışmıyor baştan yazılacak.
//    class func update(newObject : NSManagedObject){
//        var managedObject = context.object(with: newObject.objectID)
//        managedObject = newObject
//        try? context.save()
//    }
}

extension NSManagedObjectContext{
    func fetchObjects <T: NSManagedObject>(_ entityClass:T.Type,
                                           sortBy: [NSSortDescriptor]? = nil,
                                           predicate: NSPredicate? = nil) throws -> [T] {
        
        let request: NSFetchRequest<T>
        if #available(iOS 10.0, *) {
            request = entityClass.fetchRequest() as! NSFetchRequest<T>
        } else {
            let entityName = String(describing: entityClass)
            request = NSFetchRequest(entityName: entityName)
        }
        
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        request.sortDescriptors = sortBy
        
        let fetchedResult = try self.fetch(request)
        return fetchedResult
    }
}
