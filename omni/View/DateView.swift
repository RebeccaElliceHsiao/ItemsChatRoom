//
//  DateView.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit
import Foundation
import Cartography

class DateView: UIView {

    @IBOutlet weak var topView: UILabel!
    @IBOutlet weak var dateView: UILabel!

    var startDate: Date? = nil
    var endDate: Date? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let view = UINib(nibName: "DateView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addSubview(view)
        self.topView.font = UIFont.normalFont(size: 12.0)
        self.dateView.font = UIFont.normalFont(size: 20.0)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(start: startDate, end: endDate)
    }

    func configure(start startDate: Date?, end endDate: Date? ) {

        let dateFormatter = DateFormatter()
        let monthFormatter = DateFormatter()

        self.topView.text = ""
        self.dateView.text = ""

        if startDate != nil && endDate != nil {
            let currentDate = NSDate()
            let diffInDays = Calendar.current.dateComponents([.day], from: currentDate as Date, to: endDate! ).day
            if diffInDays! < 7 {
                dateFormatter.dateFormat = "EEE"
                let startDateString = dateFormatter.string(from: startDate!).uppercased()
                let endDateString = dateFormatter.string(from: endDate!).uppercased()
                if startDateString != endDateString {
                    self.topView.text = "\(startDateString) - \(endDateString)"
                } else {
                    self.topView.text = "\(startDateString)"
                }
            } else {
                monthFormatter.dateFormat = "MMM"
                let monthString = monthFormatter.string(from: startDate!).uppercased()
                let endMonthString = monthFormatter.string(from: endDate!).uppercased()

                if monthString == endMonthString {
                    self.topView.text = "\(monthString)"
                } else {
                    self.topView.text = "\(monthString) - \(endMonthString)"
                }
            }
        }
        else if startDate != nil && endDate == nil {
            let currentDate = NSDate()
            let diffInDays = Calendar.current.dateComponents([.day], from: currentDate as Date, to: startDate!).day
            if diffInDays! < 7 {
                dateFormatter.dateFormat = "EEE"
                let startDateString = dateFormatter.string(from: startDate!).uppercased()
                self.topView.text = "\(startDateString)"
            } else {
                monthFormatter.dateFormat = "MMM"
                let monthString = monthFormatter.string(from: startDate!).uppercased()
                self.topView.text = "\(monthString)"
            }
        }

        if let startDate : Date = startDate {
            dateFormatter.dateFormat = "d"
            let startDateString = dateFormatter.string(from: startDate).uppercased()
            if let dateEnd : Date = endDate {

                let endDateString = dateFormatter.string(from: dateEnd)
                self.dateView.text = "\(startDateString) - \(endDateString)"
            }
            if endDate == nil {
                self.dateView.text = "\(startDateString)"
            }
        }
    }
}

