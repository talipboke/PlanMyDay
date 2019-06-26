//
//  UIViewController+Extensions.swift
//  PlanMyDay
//
//  Created by Talip on 26.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func push<T :UIViewController>(storyBoard : UIStoryboard.Storyboard? = .home,targetVC : T.Type,transitionCallBack : ((T)->())? = nil){
        
        let viewController : T = UIStoryboard.storyboard(storyboard: storyBoard!).instantiateVC()
        transitionCallBack?(viewController)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}
