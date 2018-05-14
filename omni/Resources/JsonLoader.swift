//
//  JsonLoader.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/05.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import Foundation
import CoreData

func populateItems() -> [Conversation] {

    let jsonData = loadData(fromFile: "items")
    if let items = Interactor().fetchOrCreateObjects(from: jsonData) as? [Conversation] {
        return items
    }
    return []
}

func loadData(fromFile file: String) -> [[String: Any]] {
    let filePath = Bundle.main.path(forResource: file, ofType: "json")!
    let data = NSData(contentsOfFile: filePath)!
    let dict = try! JSONSerialization.jsonObject(with: data as Data,
                                                 options: JSONSerialization.ReadingOptions.allowFragments) as! [[String: Any]]
    return dict
}
