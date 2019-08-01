//
//  CoreDataManager.swift
//  PlanMyDay
//
//  Created by Talip on 27.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

protocol CoreDataProtocol{
    func fetch<M : NSManagedObject>(dbEntity : M.Type) throws -> Variable<[M]>
    func delete(by objectID: NSManagedObjectID) throws
    func insert<M : NSManagedObject>(type : M.Type , changeOnObject : (M)->()) throws
    func update<M : NSManagedObject>(newObject : M.Type , MOid : NSManagedObjectID , changeOnObject : (M?)->()) throws
    func createTemporaryObject<M : NSManagedObject>(type : M.Type) -> M?
}

enum CoreDataManagerError : Error{
    case fetching(errorDescription : String)  // TODO : Buraya açıklaması özellikle yazılması gerekebilir.
    case saving(errorDescription : String)
    case deleting(errorDescription : String)
    case updating(errorDescription : String)
}

class CoreDataManager : CoreDataProtocol{
  
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PlanMyDay")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    init() {}
    
    // MARK: - Core Data Saving support
    
    final func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    ///DB'ye yazmadan M tipinde obje oluşurmamızı sağlar.
    func createTemporaryObject<M : NSManagedObject>(type : M.Type) -> M?{
        if let entity = NSEntityDescription.entity(forEntityName: type.description(), in: self.persistentContainer.viewContext){
            let object = NSManagedObject.init(entity: entity, insertInto: nil)
            return object as? M
        }else{
            return nil
        }
    }
    
    func fetch<M : NSManagedObject>(dbEntity : M.Type) throws -> Variable<[M]>{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: dbEntity.description())

        //var result = [M]()
        
        let result: Variable<[M]> = Variable([])

        do {
            // Execute Fetch Request
            let records = try persistentContainer.viewContext.fetch(fetchRequest)

            if let records = records as? [M] {
                result.value = records
            }

        } catch {
            throw CoreDataManagerError.fetching(errorDescription : error.localizedDescription)
            //print("Unable to fetch managed objects for entity \(dbEntity.className).")
        }
        return result
    }

    
    func insert<M : NSManagedObject>(type : M.Type , changeOnObject : (M)->()) throws{
        
        let newObject = M(context: persistentContainer.viewContext)
        changeOnObject(newObject)
        
        do{
            try persistentContainer.viewContext.save()
        }catch{
            throw CoreDataManagerError.saving(errorDescription: error.localizedDescription)
        }
    
    }
    
    func delete(by objectID: NSManagedObjectID) throws {

        // TODO : Error handling ' i yazılacak.
        
        let managedObject = persistentContainer.viewContext.object(with: objectID)
        persistentContainer.viewContext.delete(managedObject)
        
        do{
            try persistentContainer.viewContext.save()
        }catch{
            throw CoreDataManagerError.deleting(errorDescription: error.localizedDescription)
        }
        
    }
    
    func update<M : NSManagedObject>(newObject : M.Type , MOid : NSManagedObjectID , changeOnObject : (M?)->()) throws{
        
        let managedObject = persistentContainer.viewContext.object(with: MOid) as? M
        changeOnObject(managedObject)
        
        do{
            try persistentContainer.viewContext.save()
        }catch{
            throw CoreDataManagerError.updating(errorDescription : error.localizedDescription)
        }
    }
}
