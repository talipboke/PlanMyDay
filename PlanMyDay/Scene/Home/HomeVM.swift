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
    
    ///Uygulamadaki yapılacaklar listesini tutan değişkendir.
    internal lazy var taskList: Variable<[TodoTask]> = Variable([])
    
    //TODO : CoreDataManager weak ' e çekilecek yoksa bağlı olduğu obje silindiğinde ARC ' den silinemeyecek ve memory leak oluşturacak.
    private let coreDataManager : CoreDataManager
    init(coreDataManager : CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    //TODO : Unit testi yazılacak.
    func fetchToDoListFromDB(){
        
        let todoList = try? coreDataManager.fetch(dbEntity: ToDoEntitiy.self)
        
        //Rxswift NSManagerObject'i desteklemediği için for ile döndüm :D
        var tempTaskList = [TodoTask]()
        for task in todoList ?? [] {
            let tempTask = TodoTask.init(longDescription: task.longDescription ?? "" , MOId: task.objectID)
            tempTaskList.append(tempTask)
            
        }
        self.taskList.value = tempTaskList
    }
    
    //Unit testi yazılacak.
    func insertNewTaskToDB(longDescription : String){
    
        try! coreDataManager.insert(type: ToDoEntitiy.self) { (toDoEntity) in
            toDoEntity.longDescription = longDescription
        }
    }
    
    //TODO : Unit testi yazılacak.
    func deleteFromDB(by index : Int){
        
        try! coreDataManager.delete(by: taskList.value[index].id)
        taskList.value.remove(at: index)
    }
    
    //TODO : Unit testiyazılacak.
    func updateFromDB(by index : Int , updatedTask : TodoTask){
        print(taskList.value[index].id)
        
        try! coreDataManager.update(newObject: ToDoEntitiy.self, MOid: taskList.value[index].id) { (newObject) in
            newObject?.longDescription = updatedTask.longDescription
        }
        
        taskList.value[index] = updatedTask
    }
    
}
