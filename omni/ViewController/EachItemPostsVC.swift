//
//  Item'sPostsVC.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class EachItemPostsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var creatPostButton: PinkButton!

    let item: Item
    let interactor = PostInteractor()

    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
        self.interactor.fetchPost(item: item) { (_) in
            self.tableView.reloadData()
        }
        self.navigationItem.title = item.item_name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")

        self.creatPostButton.configure(title: "Create Post")
        self.creatPostButton.addTarget(self, action: #selector(createPostPressed), for: .touchUpInside)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.posts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell,
            let post = item.posts?[indexPath.row] as? Post else {
            return UITableViewCell()
        }
        cell.configure(with: post)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let post = item.posts?[indexPath.row] as? Post else { return }
        let vc = ChatViewController(post: post)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func createPostPressed() {
        let vc = MakeEventVC(post: post)
        self.present(vc, animated: true, completion: nil)
    }

}
