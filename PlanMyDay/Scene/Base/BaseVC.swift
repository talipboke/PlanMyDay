//
//  BaseVC.swift
//  PlanMyDay
//
//  Created by Talip on 24.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class BaseVC<V : UIView> : UIViewController {
    
    public var castedView: V! {
        guard isViewLoaded else { return nil }
        return view as? V //as! V
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
}
