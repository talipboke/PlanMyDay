//
//  String+Extensions.swift
//  PlanMyDay
//
//  Created by Talip on 26.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import Foundation



extension String{
    func left(_ number:Int) -> String{
        
        if number <= self.count{
            let index = self.index(self.startIndex, offsetBy: number)
            let mySubstring = self[..<index]
            return(String(mySubstring))
        }else{
            return self
        }
        
    }
}

