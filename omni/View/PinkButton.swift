//
//  commentButton.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/06.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class PinkButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        self.backgroundColor = UIColor(red: 1.0, green: 45.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        self.setTitleColor(UIColor.white, for: .normal)
        self.tintColor = UIColor.white
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        self.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 10)

        self.titleLabel?.font = UIFont(name: "Helvetica", size: 14)!
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.5
    }

    func configure(title: String) {
        self.setTitle(title, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.bounds.height / 2.0
    }

}
