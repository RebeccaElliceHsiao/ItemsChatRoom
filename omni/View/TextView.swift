//
//  TextView.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/06.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class TextView: UITextView, UITextViewDelegate {

    private var heightConstraint: NSLayoutConstraint?
    private var originalHeight: CGFloat = 0
    private var maxHeight: CGFloat?

    public func textViewDidChange(_ textView: UITextView) {
        self.supportGrowth()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.heightConstraint?.constant = self.originalHeight
    }

    func growableTextView(heightConstraint: NSLayoutConstraint?, maxHeight: CGFloat? = nil) {
        self.delegate = self
        self.heightConstraint = heightConstraint
        if let height = self.heightConstraint?.constant {
            self.originalHeight = height
        }
        self.maxHeight = maxHeight
    }

    private func supportGrowth() {
        if let heightConstraint = self.heightConstraint {
            let size = self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
            if heightConstraint.constant != size.height {
                if let maxHeight = self.maxHeight {
                    if size.height > maxHeight {
                        self.isScrollEnabled = true
                        return
                    }
                }
                self.isScrollEnabled = false
                let heightDiff = size.height - heightConstraint.constant
                self.heightConstraint?.constant += heightDiff
            }
        }
    }

}
