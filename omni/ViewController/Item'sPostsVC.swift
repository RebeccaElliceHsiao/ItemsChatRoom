//
//  Item'sPostsVC.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class Item_sPostsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var creatPostButton: PinkButton!

    let item: Item
    var posts: [Post] = []
//    let interactor = MessageInteractor()

    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
//        self.interactor.fetchMessages(item: item) { (_) in
            self.tableView.reloadData()
//        }
        self.navigationItem.title = item.item_name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.creatPostButton.configure(title: "Create Post")
        self.creatPostButton.addTarget(self, action: #selector(createPostPressed), for: .touchUpInside)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.posts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }

    @objc func createPostPressed() {

    }

}
