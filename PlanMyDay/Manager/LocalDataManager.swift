//
//  LocalDataManager.swift
//  PlanMyDay
//
//  Created by Talip on 24.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import CoreData
import Foundation


//TODO : Buraya lokal veri tabanı bilgileri yazılacak.
class LocalDataManager{

    init() {
    

    }
    
    
    class func get<T : NSManagedObject>(_ entity : T.Type){
        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        
       
    }
    
    
    
    
    
}


//class ToDoTask : NSManagedObject{
//    
//    @NSManaged public var  longDescription : String
//    @NSManaged public var  title : String
//}
