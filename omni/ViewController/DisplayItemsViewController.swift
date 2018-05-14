//
//  DisplayItemsViewController.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/06.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class DisplayItemsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var conversations: [Conversation] = populateItems()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepopulateSomeImages()

        let nib = UINib(nibName: "ItemImageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self

        headerLabel.textAlignment = .center
        headerLabel.text = "Try tapping your favorite!"

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: self.view.bounds.width/2 - 15, height: self.view.bounds.width/2 - 15)
            layout.minimumLineSpacing = 20
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ItemImageCell
        let item = conversations[indexPath.row]
        cell.configure(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath)
        let conversation = conversations[indexPath.row]
        let vc = ChatViewController(conversation: conversation)

        self.animateCell(cell: cell, vc: vc)
    }

    private func prepopulateSomeImages() {
        loadMoreImage(currIndex: 0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.collectionView.reloadData()
        })
    }

    private func loadMoreImage(currIndex: Int) {
        var currIndex = currIndex
        while currIndex < self.conversations.count {
            self.conversations[currIndex].parseImages()
            currIndex += 1
            if currIndex % 50 == 0 { break }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute: {
            self.loadMoreImage(currIndex: currIndex)
        })
    }

    private func animateCell(cell: UICollectionViewCell?, vc: UIViewController) {
        if let cell = cell {
            let frame = cell.frame
            let radius = cell.layer.cornerRadius
            UIView.animate(withDuration: 0.8, animations: {
                cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2 * 2.0))
                cell.frame.size = CGSize(width: self.view.bounds.height / 2, height: self.view.bounds.height / 2)
                cell.layer.cornerRadius = cell.frame.size.width / 2
                cell.alpha = 0

                cell.center.y = self.view.bounds.height/2
                if cell.center.x < self.view.center.x {
                    cell.center.x = cell.center.x + self.view.bounds.width/2
                } else {
                    cell.center.x = cell.center.x - self.view.bounds.width/2
                }
            }) { (Void) in
                UIView.animate(withDuration: 0.1, animations: {
                    cell.transform = .identity
                    cell.alpha = 1
                    cell.frame = frame
                    cell.layer.cornerRadius = radius
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
