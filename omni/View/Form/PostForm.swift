//
//  PostForm.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit
import Cartography

class PostEventForm: UIView {

    private var stackView = UIStackView()
    private var profileLineView = LabelAndTextInputView(frame: CGRect.zero)
    private var from = LabelAndTextInputView(frame: CGRect.zero)
    private var to = LabelAndTextInputView(frame: CGRect.zero)
    private var location = LabelAndTextInputView(frame: CGRect.zero)
    private var additionalNotes = LabelAndTextInputView(frame: CGRect.zero)

    private var postType: PostType = .request
    var post: Post?

    init(post: Post?) {
        self.post = post

        super.init(frame: CGRect.zero)
        if let post = self.post {
            self.switchForm(postType: post.postType())
            self.prepopulateForm(post: post)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(width: CGFloat) {
        self.stackView.axis = .vertical
        self.stackView.alignment = .fill
        self.addSubview(self.stackView)
        self.switchForm(postType: .request)

        constrain(self.stackView, self) { (stackView, selfView) in
            stackView.edges == selfView.edges
        }
    }

    func switchForm(postType: PostType) {
        self.postType = postType

        for subview in self.stackView.arrangedSubviews {
            self.stackView.removeArrangedSubview(subview)
        }

        let toAndFromStackView = UIStackView()
        toAndFromStackView.axis = .horizontal

        self.profileLineView.labelText = "Topic"
        self.from.labelText = "FROM (if applicable)"
        self.to.labelText = "TO (if applicable)"
        self.location.labelText = "LOCATION (if applicable)"
        self.additionalNotes.labelText = "ADDITIONAL NOTES"
        self.location.configureForPicker(options: ["My Place", "Your Place", "Other"])

        self.additionalNotes.configureForFreeformInput()
        self.to.configureForDateAndTimeInput()
        self.from.configureForDateAndTimeInput()
        self.to.configureNotTypable()
        self.from.configureNotTypable()

        self.profileLineView.addBorders(edges: .bottom)
        self.to.addBorders(edges: .bottom)
        self.from.addBorders(edges: .bottom)
        self.from.addBorders(edges: .right)
        self.location.addBorders(edges: .bottom)

        var postTypeString = ""
        switch postType {
        case .request:
            postTypeString = "request"
        case .offer:
            postTypeString = "offer"
        }

        self.profileLineView.placeholder = "Why do you want to \(postTypeString) this \(post?.item?.item_name ?? "item")?"
        self.location.placeholder = "My Place, Your Place, Other"
        self.additionalNotes.placeholder = "Anything you want to let the other part know"

        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addArrangedSubview(self.profileLineView)
        toAndFromStackView.addArrangedSubview(self.from)
        toAndFromStackView.addArrangedSubview(self.to)
        toAndFromStackView.distribution = .fillEqually
        self.stackView.addArrangedSubview(toAndFromStackView)
        self.stackView.addArrangedSubview(self.location)
        self.stackView.addArrangedSubview(self.additionalNotes)

        let height = self.stackView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        self.bounds.size = CGSize(width: self.bounds.width, height: height)
    }

    func validateField() -> Bool {
        return self.from.validate() && self.location.validate()
    }

    func makePost() -> Post {
        var post: Post! = self.post
        if post == nil {
            if self.postType == .request {
                post = Request.createNew()
            } else if self.postType == .offer {
                post = Offer.createNew()
            }
        }
        post?.text = self.profileLineView.text
        post?.from = self.from.date
        post?.to = self.to.date
        post?.flexibleHours = self.from.flexibleHours ?? true
        post?.location = self.location.text
        post?.additionalNotes = self.additionalNotes.text
        post?.creator = User.currentUser

        return post
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.stackView.frame = self.bounds
    }

    func prepopulateForm(post: Post) {

        if let text = post.text {
            self.profileLineView.textView.string = text
        }
        self.profileLineView.textView.delegate?.textViewDidChange?(self.profileLineView.textView)

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        if let from = post.from {
            self.from.textView.string = formatter.string(from: from)
        }
        if let to = post.to {
            self.to.textView.string = formatter.string(from: to)
        }
        if let location = post.location {
            self.location.textView.string = location
        }
        if let notes = post.additionalNotes {
            self.additionalNotes.textView.string = notes
        }
    }

}
