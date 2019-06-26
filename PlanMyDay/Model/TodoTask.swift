//
//  TodoTask.swift
//  PlanMyDay
//
//  Created by Talip on 26.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import Foundation


class TodoTask {
    var title : String{
        return longDescription.left(20)
    }
    var longDescription : String = ""
    
    
    init(longDescription : String? = "") {
        
        self.longDescription = longDescription!
    }
}
