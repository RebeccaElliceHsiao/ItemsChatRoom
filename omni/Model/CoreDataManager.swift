//
//  CoreDataManager.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/05.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {

    var context: NSManagedObjectContext!
    static let shared: CoreDataManager = CoreDataManager()

    class func setUpCoreDataStack() {
        let container = NSPersistentContainer(name: "omni")
        container.loadPersistentStores { (store, error) in
            guard error == nil else { NSLog("Failed to load core data stack!"); return }
            shared.context = container.viewContext
            NSLog("Loaded store!")
        }
    }

    class func resetStore() {
        let container = NSPersistentContainer(name: "omni")

        container.loadPersistentStores { (store, error) in
            let coordinator = container.persistentStoreCoordinator
            let stores = coordinator.persistentStores
            for store in stores {
                if let path = store.url?.path {
                    try! FileManager.default.removeItem(atPath: path)
                }
                try! coordinator.remove(store)
            }
        }
        self.setUpCoreDataStack()
    }

}

