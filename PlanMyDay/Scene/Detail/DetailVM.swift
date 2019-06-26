//
//  DetailVM.swift
//  PlanMyDay
//
//  Created by Talip on 26.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import Foundation

class DetailVM : BaseVM{
    
    
    typealias DetailTuple = (index : Int? , task : TodoTask)
    
    var detailTask : DetailTuple = (0,TodoTask())
    var pageType : DetailPageType = .detail
    
    var addedNewTask : ((TodoTask)->())?
    
    
    var editedTheTask : ((DetailTuple,_ isDeleted : Bool) ->())?
}
