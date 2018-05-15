//
//  Font.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

extension UIFont {

    class func normalFont(size: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "GothamPro", size: size)!
    }

    class func boldFont(size: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: size)!
    }

}
