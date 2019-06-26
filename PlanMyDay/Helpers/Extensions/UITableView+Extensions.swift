//
//  UITableView+Extensions.swift
//  PlanMyDay
//
//  Created by Talip on 26.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import UIKit

extension UITableView{
    func register(cellIdentifier : String){
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
}
