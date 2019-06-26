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
    
}
