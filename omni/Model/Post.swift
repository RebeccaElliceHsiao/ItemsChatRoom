//
//  Post.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import Foundation

@objc(Post)
class Post: NSManagedObject {

    typealias T = Post

    @NSManaged var id: String
    @NSManaged var text: String?
    @NSManaged var from: Date?
    @NSManaged var to: Date?
    @NSManaged var flexibleHours: Bool
    @NSManaged var location: String?
    @NSManaged var additionalNotes: String?
    @NSManaged var timestamp: Date?
    @NSManaged var creator: String?

    @NSManaged var item: Item?
    @NSManaged var messages: NSMutableOrderedSet?

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
        if let from = dict["from_date"] as? String {
            self.from = Date.iso8601.date(from: from)
        }
        if let to = dict["to_date"] as? String {
            self.to = Date.iso8601.date(from: to)
        }
        if let location = dict["location"] as? String {
            self.location = location
        }
        if let additionalNotes = dict["additional_notes"] as? String {
            self.additionalNotes = additionalNotes
        }
        if let creator = dict["creator"] as? String {
            self.creator = creator
        }
        if let timestamp = dict["time_created"] as? String {
            if let date = Date.isoDate(from: timestamp) {
                self.timestamp = date
            }
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
        if let from = self.from {
            dict["from_date"] = from.isoString()
        }
        if let to = self.to {
            dict["to_date"] = to.isoString()
        }
        if let location = self.location {
            dict["location"] = location
        }
        if let additionalNotes = self.additionalNotes {
            dict["additional_notes"] = additionalNotes
        }
        if let item_id = self.item?.id {
            dict["item_id"] = item_id
        }
        if let creator = self.creator {
            dict["creator"] = creator
        }
        return dict
    }

    func postType() -> PostType {
        if self is Request {
            return .request
        } else if self is Offer {
            return .offer
        }
    }
}
