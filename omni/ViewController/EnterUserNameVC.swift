//
//  EnterUserNameVC.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class EnterUserNameVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submit: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        submit.addTarget(self, action: #selector(submitPressed), for: .touchUpInside)
    }

    @objc func submitPressed() {
        if textField.text == "" {
            User.currentUser = "Anonymous"
        } else {
            User.currentUser = textField.text
        }
        let nav = UINavigationController(rootViewController: DisplayItemsViewController())
        self.present(nav, animated: true, completion: nil)
    }

}
