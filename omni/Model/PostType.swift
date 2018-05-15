//
//  PostType.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

enum PostType {
    case request, offer, event

    func name() -> String {
        switch self {
        case .request:
            return "Request"
        case .offer:
            return "Offer"
        case .event:
            return "Event"
        }
    }

}
