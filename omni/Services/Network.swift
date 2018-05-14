//
//  Network.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/06.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkRequest {

    let method: HTTPMethod
    let path: String
    let params: [String: Any]

    var domain: String = "https://omniapi.herokuapp.com"

    init(method: HTTPMethod, path: String, params: [String: Any] = [:]) {
        self.method = method
        self.path = path
        self.params = params
    }

}

class Network {

    static let shared = Network()

    func send(request: NetworkRequest, completion: ((Any?, Error?) -> Void)?) {
        var urlString = "\(request.domain)/\(request.path)"

        var urlRequest: URLRequest
        if request.method == .post {
            let url = URL(string: urlString)!
            urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"

            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            try! urlRequest.httpBody = JSONSerialization.data(withJSONObject: request.params,
                                                              options: JSONSerialization.WritingOptions.init(rawValue: 0))
        } else {
            guard let id = request.params["id"] as? String else { return }
            urlString += "/\(id)"
            let url = URL(string: urlString)!
            urlRequest = URLRequest(url: url)
            if request.method == .delete {
                urlRequest.httpMethod = "DELETE"
            } else if request.method == .get {
                urlRequest.httpMethod = "GET"
            } else {
                fatalError("Unsupported HTTP Method!")
            }

        }

        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            if let data = data {
                let jsonData = try! JSONSerialization.jsonObject(with: data,
                                                                 options: JSONSerialization.ReadingOptions.init(rawValue: 0))
                DispatchQueue.main.async {
                    completion?(jsonData, error)
                }
            } else {
                DispatchQueue.main.async {
                    completion?(nil, error)
                }
            }
        }
        task.resume()
    }

}
