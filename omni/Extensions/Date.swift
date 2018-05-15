//
//  Date.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import Foundation
extension Date {

    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static func isoDate(from string: String) -> Date? {
        return Date.iso8601.date(from: string)
    }

    func isoString() -> String? {
        return Date.iso8601.string(from: self)
    }

}
