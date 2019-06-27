//
//  HomeVM.swift
//  PlanMyDay
//
//  Created by Talip on 24.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import Foundation

import RxSwift //Autocomplete ve okumama sorunundan dolayı yazıldı.

class HomeVM : BaseVM {
    
    //TODO : CoreDataManager inject edilecek.
    
    ///Uygulamadaki yapılacaklar listesini tutan değişkendir.
    internal lazy var taskList: Variable<[TodoTask]> = Variable([])
    
    
    //TODO : Unit testi yazılacak.
    func fetchToDoListFromDB(){
        let todoList = CoreDataManager.fetch(dbEntity: ToDoEntitiy.self)
        
        //Rxswift NSManagerObject'i desteklemediği için for ile döndüm :D
        var tempTaskList = [TodoTask]()
        for task in todoList{
            let tempTask = TodoTask.init(longDescription: task.longDescription ?? "" , MOId: task.objectID)
            tempTaskList.append(tempTask)
            
        }
        self.taskList.value = tempTaskList
    }
    
    func insertNewTaskToDB(longDescription : String){
        let newObject = ToDoEntitiy(context: CoreDataManager.context)
        newObject.longDescription = longDescription
        try? CoreDataManager.context.save()
    }
    
    //TODO : Unit testi yazılacak.
    func deleteFromDB(by index : Int){
        CoreDataManager.delete(by: taskList.value[index].id)
        taskList.value.remove(at: index)
    }
    
    //TODO : Unit testiyazılacak.
    func updateFromDB(by index : Int , updatedTask : TodoTask){
        print(taskList.value[index].id)
        //Type casting'den dolayı farklı bir metod bulunmalı generik yapılması için.
        let managedObject = CoreDataManager.context.object(with: taskList.value[index].id) as? ToDoEntitiy
        managedObject?.longDescription = updatedTask.longDescription
        try? CoreDataManager.context.save()
        
       // CoreDataManager.update(newObject: NSManagedObject())
        taskList.value[index] = updatedTask
        
    }
    
}
