//
//  PostCell.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    func configure(with post: Post) {

        self.bodyLabel.textColor = UIColor.darkGray
        self.bodyLabel.text = "\(post.text ?? "...")"
        self.titleLabel.attributedText = post.posterWithPostTypeAttributedString()
        self.backView.layer.cornerRadius = 8

        if post is Request {
            backView.backgroundColor = #colorLiteral(red: 0.9993898273, green: 0.1007643119, blue: 0.3069936335, alpha: 1)
        }
        if post is Offer {
            backView.backgroundColor = #colorLiteral(red: 0.9689884782, green: 0.6393168569, blue: 0.6731092334, alpha: 1)
        }
    }
}
