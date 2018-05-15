//
//  Item.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/05.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import CoreData
import UIKit

@objc(Item)
class Item: NSManagedObject, FetchOrCreatable{

    typealias T = Item

    @NSManaged var id: String
    @NSManaged var item_name: String?
    @NSManaged var item_photo_url: String?

    @NSManaged var posts: NSMutableOrderedSet?

    var image: UIImage?

    func parse(dict: [String: Any]) {
        if let id = dict["id"] as? String {
            self.id = id
        }
        if let name = dict["name"] as? String {
            self.item_name = name
        }
        if let photo_url = dict["key_image"] as? String {
            self.item_photo_url = photo_url
        }
    }

    func parseImages() {
        guard let url = self.item_photo_url else { return }
        let imageUrl: URL = URL(string: url)!
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageData: NSData = NSData(contentsOf: imageUrl) {
                self.image = UIImage(data: imageData as Data)
            }
        }
    }

}
