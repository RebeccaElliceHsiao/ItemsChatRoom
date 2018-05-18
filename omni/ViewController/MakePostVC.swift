//
//  MakePostVC.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//
import UIKit
import Cartography

class MakePostVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var eventTypeToggle: UIStackView!
    @IBOutlet weak var toggleContainerView: UIView!
    @IBOutlet weak var scrollViewConstraint: NSLayoutConstraint!
    
    private let post: Post?
    private var postType: PostType = .request
    private var form: PostEventForm!

    private var interactor = PostInteractor()

    init(post: Post? = nil) {
        if post is Request {
            self.postType = .request
        } else if post is Offer {
            self.postType = .offer
        } 
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupForm()

        if let _ = self.post {
            self.title = "New Post"
        }

        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonSelected))

        toggleContainerView.layer.cornerRadius = 4.0
        toggleContainerView.clipsToBounds = true
        view.backgroundColor = UIColor(red: 220.0/255.0, green: 235.0/255.0, blue: 248.0/255.0, alpha: 1.0)

        setupToggle(for: self.postType)

        self.scrollView.isDirectionalLockEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false

        self.postButton.configureDarkGray(title: "Post")
        self.postButton.backgroundColor = UIColor.redPink
        self.postButton.layer.cornerRadius = 5.0
        self.postButton.clipsToBounds = true
        self.postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)

        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow),
                           name: .UIKeyboardWillShow,
                           object: nil)

        center.addObserver(self,
                           selector: #selector(keyboardWillHide),
                           name: .UIKeyboardWillHide,
                           object: nil)

        constrain(self.form, self.scrollView) { (form, scroll) in
            form.edges == scroll.edges
            form.width == scroll.width
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = self.view.bounds.width - 32
        let height = self.form.systemLayoutSizeFitting(CGSize.zero).height

        self.scrollView.contentSize = CGSize(width: width, height: self.toggleContainerView.frame.height + height + 30)
    }

    // MARK: - Keyboard Handlers

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let cgRect = keyboardFrame.cgRectValue
            let tabHeight = self.tabBarController?.tabBar.frame.height ?? 0
            self.scrollViewConstraint.constant = cgRect.height - tabHeight
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.scrollViewConstraint.constant = 82.0
    }


    func setupToggle(for type: PostType) {
        for subview in eventTypeToggle.arrangedSubviews {
            eventTypeToggle.removeArrangedSubview(subview)
        }
        eventTypeToggle.distribution = .fillEqually
        eventTypeToggle.layer.cornerRadius = 4.0
        eventTypeToggle.clipsToBounds = true
        let nib = UINib(nibName: "RadioButton", bundle: nil)
        let requestOption = nib.instantiate(withOwner: nil, options: nil).first as! RadioButton
        let offerOption = nib.instantiate(withOwner: nil, options: nil).first as! RadioButton
        requestOption.active = type == .request
        offerOption.active = type == .offer
        requestOption.configureAsRequest()
        offerOption.configureAsOffer()
        eventTypeToggle.addArrangedSubview(requestOption)
        eventTypeToggle.addArrangedSubview(offerOption)

        if self.post == nil {
            let requestGesture = UITapGestureRecognizer(target: self, action: #selector(requestOptionSelected))
            requestOption.addGestureRecognizer(requestGesture)
            let offerGesture = UITapGestureRecognizer(target: self, action: #selector(offerOptionSelected))
            offerOption.addGestureRecognizer(offerGesture)
        }
    }

    private func setupForm() {
        self.form = PostEventForm(post: self.post)
        self.scrollView.addSubview(self.form)
        self.form.setup(width: self.view.bounds.width - 32)

        self.form.layer.cornerRadius = 4.0
        self.form.clipsToBounds = true
    }

    @objc func requestOptionSelected() {
        postType = .request
        setupToggle(for: .request)
        self.form.switchForm(postType: .request)
    }

    @objc func offerOptionSelected() {
        postType = .offer
        setupToggle(for: .offer)
        self.form.switchForm(postType: .offer)
    }

    @objc func cancelButtonSelected() {
        dismiss(animated: true, completion: nil)
    }

    @objc func postButtonPressed(_ button: UIButton) {
        let post = self.form.makePost()
        self.interactor.createPost(post: post) { (post, error) in
            self.dismiss(animated: true, completion: nil)
        }
    }

}

