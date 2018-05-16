//
//  Interactor.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/06.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

class Interactor {

    @discardableResult func fetchOrCreateObjects(from data: Any?) -> [Any] {
        var objects: [Any] = []
        if let data = data as? [[String: Any]] {
            for objectDict in data {
                if objectDict["name"] != nil || objectDict["favorited"] != nil {
                    let item = Item.fetchOrCreate(with: objectDict)
                    objects.append(item)
                } else {
                    if let type = objectDict["type"] as? String {
                        if type == "Request" {
                            let object = Request.fetchOrCreate(with: objectDict)
                            objects.append(object)
                        } else if type == "Offer" {
                            let object = Offer.fetchOrCreate(with: objectDict)
                            objects.append(object)
                        }
                    } else {
                        let object = Message.fetchOrCreate(with: objectDict)
                        objects.append(object)
                    }
                }
            }
        } else if let data = data as? [String: Any] {
            if let type = data["type"] as? String {
                if type == "Request" {
                    let object = Request.fetchOrCreate(with: data)
                    objects.append(object)
                } else if type == "Offer" {
                    let object = Offer.fetchOrCreate(with: data)
                    objects.append(object)
                }
            } else {
                let object = Message.fetchOrCreate(with: data)
                objects.append(object)
            }
        }
        try! CoreDataManager.shared.context.save()
        return objects
    }

//    func processEdge(data: [String: Any]) {
//        if let itemID = data["item_id"] as? String,
//            let messageID = data["id"] as? Int {
//            if let item = Item.fetch(with: itemID),
//                let message = Message.fetch(with: String(messageID)) {
//                item.messages?.add(message)
//            }
//        }
//    }

    func processEdges(data: [[String: Any]]) {
        guard let itemID = data.first?["item_id"] as? String else { return }
        guard let item = Item.fetch(with: itemID)  else { return }
        item.messages = nil
        for dict in data {
            guard let commentid = dict["id"] as? Int else { continue }
            let commentId = String(commentid)
            if let comment = Message.fetch(with: commentId) {
                item.messages?.add(comment)
            }
        }
    }
}
