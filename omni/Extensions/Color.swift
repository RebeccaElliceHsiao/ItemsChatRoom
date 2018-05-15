//
//  color.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

extension UIColor {

    class var request: UIColor {
        get {
            return UIColor(red: 1.0, green: 45.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        }
    }

    class var offer: UIColor {
        get {
            return UIColor(red: 253.0/255.0, green: 167.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        }
    }

    class var inactive: UIColor {
        get {
            return UIColor(white: 0.8, alpha: 1.0)
        }
    }
}
