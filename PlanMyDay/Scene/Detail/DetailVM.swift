//
//  DetailVM.swift
//  PlanMyDay
//
//  Created by Talip on 26.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import Foundation


class DetailVM : BaseVM{
    
    private let coreDataManager = CoreDataManager()
    
    typealias DetailTuple = (index : Int? , task : ToDoEntitiy)
    
    var detailTask : DetailTuple = (0,ToDoEntitiy())
    var pageType : DetailPageType = .detail
    
    var addedNewTask : ((ToDoEntitiy)->())?
    
    
    var editedTheTask : ((DetailTuple,_ isDeleted : Bool) ->())?
    
    func createAndSetObject(longDescription : String){

        if let newTask = coreDataManager.createTemporaryObject(type: ToDoEntitiy.self){
            newTask.longDescription = longDescription
            self.detailTask.task = newTask
        }
    }
}
