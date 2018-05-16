//
//  PickerDataSource.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/16.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class PickerDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    var options: [String]
    init(options: [String]) {
        self.options = options
    }

    // MARK: - UIPickerViewDataSource & UIPickerViewDelegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

}
