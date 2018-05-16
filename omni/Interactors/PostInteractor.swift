//
//  PostInteractor.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import Foundation
import CoreData

class PostInteractor: Interactor {

    func createPost(post: Post, completionHandler:@escaping ((Post?, Error?) -> Void)) {
        let params: [String: Any] = post.makeDict()
        let path = "post"

        let request = NetworkRequest(method: .post, path: path, params: params)
        Network.shared.send(request: request) { (jsonData, error) in
            if let jsonData = jsonData as? [String: Any] {
                if let data = jsonData["data"] as? [String: Any] {
                    let object = self.fetchOrCreateObjects(from: data)
                    let post = self.getPost(from: object)
                    completionHandler(post, error)
                }
            }
            completionHandler(nil, error)
        }
    }

    func fetchPost(item: Item, completionHandler:@escaping ((Error?) -> Void)) {
        let params: [String: Any] = ["id": item.id]
        let path = "item"
        var request = NetworkRequest(method: .get, path: path)

        Network.shared.send(request: request) { (jsonData, error) in
            if let jsonData = jsonData as? [String: Any] {
                if let data = jsonData["data"] as? [[String: Any]] {
                    self.fetchOrCreateObjects(from: data)
                    self.processEdges(data: data)
                }
            }
            completionHandler(error)
        }
    }

    func deletePost(post: Post, completionHandler:@escaping ((Error?) -> Void)) {
        let params: [String: Any] = ["id": post.id]
        let path = "post"
        let request = NetworkRequest(method: .delete, path: path, params: params)
        Network.shared.send(request: request) { (data, error) in
            CoreDataManager.shared.context.delete(post)
            completionHandler(error)
        }
    }

    func updatePost(post: Post, completionHandler:@escaping ((Post?, Error?) -> Void)) {
        let params: [String: Any] = post.makeDict()
        let path = "post"
        let request = NetworkRequest(method: .put, path: path, params: params)
        Network.shared.send(request: request) { (jsonData, error) in
            if let jsonData = jsonData as? [String: Any] {
                if let data = jsonData["data"] as? [String: Any] {
                }
            }
            completionHandler(nil, error)
        }
    }

    private func getPost(from objects: [Any]) -> Post? {
        for object in objects {
            if let post = object as? Post {
                return post
            }
        }
        return nil
    }

}
