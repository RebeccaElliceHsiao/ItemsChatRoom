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

    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }

    public var placeholder: String? {
        get {
            var placeholderText: String?

            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }

            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }

    public var string: String {
        get {
            return self.text
        }
        set {
            self.text = newValue
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.isHidden = true
            }
        }
    }

    var textViewDelegate: UITextViewDelegate? {
        didSet {
            if self.delegate == nil {
                self.delegate = textViewDelegate
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = self.viewWithTag(100) as? UILabel {
            self.resizePlaceholder()
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        self.supportGrowth()
        self.textViewDelegate?.textViewDidChange?(textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.heightConstraint?.constant = self.originalHeight
        self.textViewDelegate?.textViewDidEndEditing?(textView)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textViewDelegate?.textViewDidBeginEditing?(textView)
    }

    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY: CGFloat = CGFloat(self.offset ?? -3)
            let labelWidth = self.frame.width - (labelX * 2)
            let textHeight = self.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)).height
            let labelHeight = textHeight + labelY + 4

            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }

    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()

        placeholderLabel.numberOfLines = 0
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        placeholderLabel.isHidden = self.text.count > 0

        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        if let originalDelegate = self.delegate {
            self.textViewDelegate = originalDelegate
        }
        self.delegate = self
    }

    private func growableTextView(heightConstraint: NSLayoutConstraint?, maxHeight: CGFloat? = nil) {
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
