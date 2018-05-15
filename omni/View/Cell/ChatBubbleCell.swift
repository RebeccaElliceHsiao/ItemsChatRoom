//
//  ChatBubbleCell.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/06.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class ChatBubbleCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var chatTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastSeenLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawBezier()
    }

    func configure(message: Message) {
        self.chatTextLabel.text = message.text
        self.nameLabel.text = message.creator
        if let date = message.timestamp {
            self.lastSeenLabel.text = date.timeAgoSinceDate(numericDates: true)
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    private func drawBezier() {
        let maskPath = UIBezierPath(roundedRect: self.textContainerView.bounds,
                                    byRoundingCorners: [.bottomLeft, .topLeft, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.textContainerView.layer.mask = shape
    }
    
}
