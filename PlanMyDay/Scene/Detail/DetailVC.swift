//
//  DetailVC.swift
//  PlanMyDay
//
//  Created by Talip on 26.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import UIKit


import RxSwift

class DetailVC : BaseVC<DetailView>{
    
    
    lazy var viewModel = DetailVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderUI()
        
        self.castedView.detailTextView.rx.didChange
            .throttle(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext : { [weak self] _ in
                
                let newTask = TodoTask.init(longDescription: self?.castedView.detailTextView.text ?? "")
                self?.viewModel.detailTask.task = newTask
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    private func renderUI(){
        
        switch viewModel.pageType {
        case .detail:
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: AppConst.edit, style: .plain, target: self, action: #selector(editTheTask))
            self.navigationItem.title = viewModel.detailTask.task.title
            castedView.detailTextView.text = viewModel.detailTask.task.longDescription
 
        case .add:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: AppConst.add, style: .plain, target: self, action: #selector(addNewTask))
            self.castedView.deleteBtn.removeFromSuperview()
        }
        
    }
   
    private func sendNewTaskBack(isDeleted : Bool? = false){
        if !castedView.detailTextView.text.isEmpty{
            
            switch self.viewModel.pageType{
            case .detail:
                self.viewModel.editedTheTask?(self.viewModel.detailTask, isDeleted!)
            case .add:
                self.viewModel.addedNewTask?(self.viewModel.detailTask.task)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func deleteTheTask(_ sender: Any) {
        sendNewTaskBack(isDeleted: true)
    }

    @objc private func addNewTask(){

        sendNewTaskBack()
    }
    
    @objc private func editTheTask(){
  
        sendNewTaskBack()
        
    }
}



