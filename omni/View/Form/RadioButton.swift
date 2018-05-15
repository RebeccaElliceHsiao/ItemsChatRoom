//
//  RadioButton.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class RadioButton: UIView {

    @IBOutlet weak var dot: UIView!
    @IBOutlet weak var label: UILabel!
    
    var active = false

    override func layoutSubviews() {
        super.layoutSubviews()
        self.dot.layer.cornerRadius = self.dot.bounds.width / 2.0
        self.label.font = UIFont(name: "GothamPro", size: 13.0)
    }

    func configureAsRequest() {
        self.dot.backgroundColor = self.active ? UIColor.request : UIColor.inactive
        self.label.textColor = self.active ? UIColor.darkText : UIColor.inactive
        self.label.text = "Request"
    }

    func configureAsOffer() {
        self.dot.backgroundColor = self.active ? UIColor.offer : UIColor.inactive
        self.label.textColor = self.active ? UIColor.darkText : UIColor.inactive
        self.label.text = "Offer"
    }

}
