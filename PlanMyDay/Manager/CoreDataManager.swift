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
    func fetch<M : NSManagedObject>(dbEntity : M.Type) throws -> [M]
    func delete(by objectID: NSManagedObjectID) throws
    func insert<M : NSManagedObject>(type : M.Type , changeOnObject : (M)->()) throws
    func update<M : NSManagedObject>(newObject : M.Type , MOid : NSManagedObjectID , changeOnObject : (M?)->()) throws
}

enum CoreDataManagerError : Error{
    case fetching(errorDescription : String)  // TODO : Buraya açıklaması özellikle yazılması gerekebilir.
    case saving(errorDescription : String)
    case deleting(errorDescription : String)
    case updating(errorDescription : String)
}

class CoreDataManager : CoreDataProtocol{
  
    
    //TODO : Değişken weak ' e döndürülecek.ARC ' de memory leak almaması için.

    private(set) var context : NSManagedObjectContext
    
    init(context : NSManagedObjectContext ) {
        self.context = context
    }
    
    func fetch<M : NSManagedObject>(dbEntity : M.Type) throws -> [M]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: dbEntity.description())

        var result = [M]()

        do {
            // Execute Fetch Request
            let records = try context.fetch(fetchRequest)

            if let records = records as? [M] {
                result = records
            }

        } catch {
            throw CoreDataManagerError.fetching(errorDescription : error.localizedDescription)
            //print("Unable to fetch managed objects for entity \(dbEntity.className).")
        }

        return result
    }

    
    func insert<M : NSManagedObject>(type : M.Type , changeOnObject : (M)->()) throws{
        
        let newObject = M(context: context)
        changeOnObject(newObject)
        
        do{
            try context.save()
        }catch{
            throw CoreDataManagerError.saving(errorDescription: error.localizedDescription)
        }
    
    }
    
    func delete(by objectID: NSManagedObjectID) throws {

        // TODO : Error handling ' i yazılacak.
        
        let managedObject = context.object(with: objectID)
        context.delete(managedObject)
        
        do{
            try context.save()
        }catch{
            throw CoreDataManagerError.deleting(errorDescription: error.localizedDescription)
        }
        
    }
    
    func update<M : NSManagedObject>(newObject : M.Type , MOid : NSManagedObjectID , changeOnObject : (M?)->()) throws{
        
        let managedObject = context.object(with: MOid) as? M
        changeOnObject(managedObject)
        
        do{
            try context.save()
        }catch{
            throw CoreDataManagerError.updating(errorDescription : error.localizedDescription)
        }
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
