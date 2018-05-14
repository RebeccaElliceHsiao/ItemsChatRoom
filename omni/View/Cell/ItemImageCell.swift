//
//  ItemImageCell.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/06.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class ItemImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: ImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGray.cgColor
    }

    func configure(with item: Conversation) {
        if let name = item.item_name {
            self.label.text = name
        }
        if let image = item.image {
            self.imageView.image = image
            self.label.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.label.textColor = UIColor.white
        }
    }

    func configure(with url: String) {
        self.imageView.configure(with: url)
    }

}
