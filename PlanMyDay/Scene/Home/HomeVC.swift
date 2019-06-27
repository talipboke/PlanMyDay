//
//  ViewController.swift
//  PlanMyDay
//
//  Created by Talip on 24.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift



class HomeVC: BaseVC<HomeView> {

    
    lazy private var viewModel = HomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewModel.fetchToDoListFromDB()
        
        self.registerCells()
        
        castedView.addBtn.rx.tap
            .bind(onNext : { [unowned self] _ in
                self.navigateToDetail()
            }).disposed(by: viewModel.disposeBag)
        
        
        viewModel.taskList.asObservable()
            .bind(to: castedView.table.rx.items(cellIdentifier: TaskCell.className,cellType: TaskCell.self)) {row, element, cell in
                cell.titleLbl.text = element.title
            }
            .disposed(by: viewModel.disposeBag)
        
        
        self.castedView.table.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.navigateToDetail(indexPath)
            }).disposed(by: viewModel.disposeBag)
        
    }

    private func navigateToDetail(_ indexPath : IndexPath? = nil){
        self.push(storyBoard: .detail, targetVC: DetailVC.self, transitionCallBack: {[unowned self] (detailVC) in
            
            if let index = indexPath?.row{
                 detailVC.viewModel.detailTask = (index , self.viewModel.taskList.value[index])
                 detailVC.viewModel.pageType = .detail
            }else{
                detailVC.viewModel.pageType = .add
            }
            
            
            detailVC.viewModel.addedNewTask = { [weak self] (task) in
                self?.viewModel.taskList.value.append(task)
                self?.viewModel.insertNewTaskToDB(longDescription: task.longDescription)
            }
            
            detailVC.viewModel.editedTheTask = { [weak self] response,isDeleted in
                
                if let index = response.index{
                    
                    if isDeleted{
                        self?.viewModel.deleteFromDB(by: index)
                    }else{
                        self?.viewModel.updateFromDB(by: index , updatedTask : response.task)
                    }
                }
              
           
            }
           
        })
    }
    private func registerCells(){
        self.castedView.table.register(cellIdentifier: TaskCell.className)
    }
    
}

