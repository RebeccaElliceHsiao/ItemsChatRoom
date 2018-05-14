//
//  comment.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/05.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import CoreData

@objc(Message)
class Message: NSManagedObject, FetchOrCreatable {

    typealias T = Message

    @NSManaged var id: String
    @NSManaged var text: String?
    @NSManaged var conversation: Conversation?

    func parse(dict: [String: Any]) {
        if let id = dict["id"] as? String {
            self.id = id
        }
        if let id = dict["id"] as? Int {
            self.id = String(id)
        }
        if let text = dict["text"] as? String {
            self.text = text
        }
    }

    func makeDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        if self.id != "" {
            dict["id"] = id
        }
        if let text = self.text {
            dict["text"] = text
        }
        if let item_id = self.conversation?.id {
            dict["item_id"] = item_id
        }

        return dict
    }

}
