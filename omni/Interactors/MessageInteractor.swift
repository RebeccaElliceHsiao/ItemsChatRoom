//
//  MessageInteractor.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/06.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import Foundation
import CoreData

class MessageInteractor: Interactor {

    func createMessage(message: Message, completionHandler:@escaping ((Message?, Error?) -> Void)) {
        let params: [String: Any] = message.makeDict()
        let path = "comment"

        let request = NetworkRequest(method: .post, path: path, params: params)
        Network.shared.send(request: request) { (jsonData, error) in
            if let jsonData = jsonData as? [String: Any] {
                if let data = jsonData["data"] as? [String: Any] {
                    let object = self.fetchOrCreateObjects(from: data)
                    let message = self.getMessage(from: object)
                    completionHandler(message, error)
                }
            }
        completionHandler(nil, error)
        }
    }

    func fetchMessages(conversation: Conversation, completionHandler:@escaping ((Error?) -> Void)) {
        let params: [String: Any] = ["id": conversation.id]
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

    func deleteMessage(message: Message, completionHandler:@escaping ((Error?) -> Void)) {
        let params: [String: Any] = ["id": message.id]
        let path = "comment"
        let request = NetworkRequest(method: .delete, path: path, params: params)
        Network.shared.send(request: request) { (data, error) in
            CoreDataManager.shared.context.delete(message)
            completionHandler(error)
        }
    }

    func updateMessage(message: Message, completionHandler:@escaping ((Message?, Error?) -> Void)) {
        let params: [String: Any] = message.makeDict()
        let path = "comment"
        let request = NetworkRequest(method: .put, path: path, params: params)
        Network.shared.send(request: request) { (jsonData, error) in
            if let jsonData = jsonData as? [String: Any] {
                if let data = jsonData["data"] as? [String: Any] {
                    completionHandler(message, error)
                }
            }
            completionHandler(nil, error)
        }
    }

    private func getMessage(from objects: [Any]) -> Message? {
        for object in objects {
            if let message = object as? Message {
                return message
            }
        }
        return nil
    }

}
