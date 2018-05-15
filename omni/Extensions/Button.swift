//
//  Button.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

    func configureDarkGray(title: String) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.alloNormalFont(size: 13.0)
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = UIColor(white: 0.13, alpha: 1.0)
        self.layer.cornerRadius = 4.0
        self.clipsToBounds = true
    }

}
