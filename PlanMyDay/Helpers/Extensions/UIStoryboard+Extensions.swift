//
//  UIStoryboard+Extensions.swift
//  PlanMyDay
//
//  Created by Talip on 26.06.2019.
//  Copyright © 2019 Talip. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        
        case home
        case detail
        
        //Yeni storyboardlar aşağıdaki gibi eklenicek.
        //        case news
        //        case gallery
        var filename: String {
            return rawValue.capitalized
        }
    }
    class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    func instantiateVC<T: UIViewController>() -> T {
        //ViewController ve identifier 'ı aynı olmalı
        return self.instantiateViewController(withIdentifier: T.className) as! T
    }
}
