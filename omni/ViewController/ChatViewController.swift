//
//  ChatViewController.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/06.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var commentButton: CommentButton!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var conversation: Conversation
    var isTyping = false
    let interactor = MessageInteractor()

    init(conversation: Conversation) {
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
        self.interactor.fetchMessages(conversation: conversation) { (_) in
            self.tableView.reloadData()
        }
        self.navigationItem.title = conversation.item_name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        let nib = UINib(nibName: "ChatBubbleCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ChatBubbleCell")
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        self.sendButton.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        self.commentButton.addTarget(self, action: #selector(commentPressed), for: .touchUpInside)
        self.textView.growableTextView(heightConstraint: textHeightConstraint, maxHeight: 150)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(screenWasTapped)))

        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow),
                           name: .UIKeyboardWillShow,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(keyboardWillHide),
                           name: .UIKeyboardWillHide,
                           object: nil)

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversation.messages?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = conversation.messages?[indexPath.row] as? Message else { return UITableViewCell() }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChatBubbleCell") as! ChatBubbleCell
        cell.configure(message: message)
        return cell
    }

    @objc func commentPressed() {
        self.commentButton.isHidden = true
        self.bottomConstraint.constant = 0
        self.textView.becomeFirstResponder()
        self.isTyping = true
    }

    @objc private func screenWasTapped() {
        if self.isTyping {
            self.textView.text = ""
            self.textView.resignFirstResponder()
            self.commentButton.isHidden = false
            self.isTyping = false
            self.bottomConstraint.constant = -50
        }
    }

    @objc func sendPressed() {
        let message = Message.createNew()
        message.conversation = conversation
        message.text = self.textView.text ?? ""
        self.interactor.createMessage(message: message, completionHandler: { (message, _) in
            self.screenWasTapped()
            self.tableView.reloadData()
        })
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = frame.cgRectValue
            self.bottomConstraint.constant = keyboardFrame.height
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = 0
    }

}
