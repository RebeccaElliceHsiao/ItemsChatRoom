//
//  LabelAndTextInputView.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/14.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import Foundation
import UIKit
import Cartography

class LabelAndTextInputView: UIView {
    
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var label: UILabel!

    var date: Date?
    var flexibleHours: Bool? {
        get {
            return self.datePicker.datePickerMode == .date
        }
    }

    private var datePicker: UIDatePicker!
    private var picker: UIPickerView!
    private var pickerDataSource: (UIPickerViewDataSource & UIPickerViewDelegate)!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let nib = UINib(nibName: "LabelAndTextInputView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.addSubview(view)

        constrain(view, self) { (view, viewSelf) in
            view.edges == viewSelf.edges
        }

        self.textView.isScrollEnabled = true

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        let flexibleSeparator = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        toolbar.items = [flexibleSeparator, doneButton]
        self.textView.inputAccessoryView = toolbar

        self.label.font = UIFont.boldFont(size: 9)
        self.label.textColor = UIColor.darkGray
    }

    var required: Bool = false {
        didSet {
            configureLabelText()
        }
    }

    var labelText: String = "" {
        didSet {
            configureLabelText()
        }
    }

    var placeholder: String = "Select" {
        didSet {
            self.textView.placeholder = placeholder
        }
    }

    var text: String {
        get {
            return self.textView.text
        }
        set {
            self.textView.text = newValue
            self.textView.delegate?.textViewDidChange?(self.textView)
        }
    }

    var offset: Double {
        get {
            return self.textView.offset ?? 0
        }
        set {
            self.textView.offset = newValue
        }
    }

    func configureForNumericInput() {
        self.textView.keyboardType = .numberPad
    }

    func configureForFreeformInput() {
        self.textView.isScrollEnabled = true
    }

    func configureNotTypable() {
        self.textView.isEditable = false
    }

    func configureForDateInput(withFlexibility: Bool = false) {
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .date
        self.textView.inputView = self.datePicker
        self.textView.isScrollEnabled = false

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        if withFlexibility {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateDoneButtonWithFlexibilityPressed))
            let flexibleSeparator = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.items = [flexibleSeparator, doneButton]
        } else {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateDoneButtonPressed))
            toolbar.items = [doneButton]
        }
        self.textView.inputAccessoryView = toolbar
    }

    func configureForDateAndTimeInput() {
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .dateAndTime
        self.textView.inputView = self.datePicker
        self.textView.isScrollEnabled = false

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let flexButton = UIBarButtonItem(title: "Specify Hours", style: .done, target: self, action: #selector(flexibleTimePressed))
        let flexibleSeparator = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateDoneButtonPressed))
        toolbar.items = [flexButton, flexibleSeparator, doneButton]
        self.textView.inputAccessoryView = toolbar
    }

    func configureForTimeInput() {
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .time
        self.datePicker.minuteInterval = 15
        self.textView.inputView = self.datePicker
        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: 10, minute:0, second: 0, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        if let date = Calendar.current.date(from: dateComponents) {
            self.datePicker.date = date
        }

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        let flexibleSeparator = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(timeDoneButtonPressed))
        toolbar.items = [flexibleSeparator, doneButton]
        self.textView.inputAccessoryView = toolbar
    }

    func configureForPicker(options: [String]) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneButtonPressed))
        self.configureForPickerSettings(options: options, doneButton: doneButton)
    }

    func validate() -> Bool {
        if !self.required {
            return true
        }
        return self.textView.text.count > 0
    }

    private func configureForPickerSettings(options: [String], doneButton: UIBarButtonItem) {
        self.picker = UIPickerView()
        self.pickerDataSource = PickerDataSource(options: options)
        self.picker.dataSource = self.pickerDataSource
        self.picker.delegate = self.pickerDataSource
        self.textView.inputView = self.picker
        self.textView.isEditable = false
        self.textView.isScrollEnabled = false

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        let flexibleSeparator = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSeparator, doneButton]
        self.textView.inputAccessoryView = toolbar
    }

    @objc private func flexibleTimePressed(button: UIBarButtonItem) {
        if self.datePicker.datePickerMode == .date {
            button.title = "Flexible Hours"
            self.datePicker.datePickerMode = .dateAndTime
        } else {
            button.title = "Specify Hours"
            self.datePicker.datePickerMode = .date
        }
    }

    @objc private func dateDoneButtonPressed() {
        self.date = self.datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        self.textView.text = formatter.string(from: self.datePicker.date)
        self.textView.delegate?.textViewDidChange?(self.textView)
        self.textView.resignFirstResponder()
    }

    @objc private func dateDoneButtonWithFlexibilityPressed() {
        self.date = self.datePicker.date
        let formatter = DateFormatter()
        if self.datePicker.datePickerMode == .date {
            formatter.dateFormat = "E, MMM d"
            self.textView.text = formatter.string(from: self.datePicker.date) + " flexible"
        } else {
            formatter.dateFormat = "E, MMM d hh:mm a"
            self.textView.text = formatter.string(from: self.datePicker.date)
        }
        self.textView.delegate?.textViewDidChange?(self.textView)
        self.textView.resignFirstResponder()
    }

    @objc private func timeDoneButtonPressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        self.textView.text = formatter.string(from: self.datePicker.date)
        self.textView.delegate?.textViewDidChange?(self.textView)
        self.textView.resignFirstResponder()
    }

    @objc private func pickerDoneButtonPressed() {
        let row = self.picker.selectedRow(inComponent: 0)
        let title = self.pickerDataSource.pickerView!(self.picker, titleForRow: row, forComponent: 0)
        self.textView.text = title
        self.textView.delegate?.textViewDidChange?(self.textView)
        self.textView.resignFirstResponder()
    }

    @objc private func doneButtonPressed() {
        self.textView.resignFirstResponder()
    }

    private func configureLabelText() {
        var text = self.labelText
        if required {
            text += " *"
        }
        self.label.text = text
    }

}
