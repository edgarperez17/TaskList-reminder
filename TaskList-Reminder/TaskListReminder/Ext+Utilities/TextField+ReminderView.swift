//
//  TextField+InputView.swift
//  TaskListReminder
//
//  Created by Tyler Schwartzman on 5/3/20.
//  Copyright © 2020 Tyler_Dev. All rights reserved.
//

import UIKit

let deleteReminderImage = UIImage(systemName: "trash.circle.fill")

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 416))
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = .blueSapphire
        datePicker.setValue(UIColor.paleYellow, forKeyPath: "textColor")

        self.inputView = datePicker
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tappedCancel))
        cancel.tintColor = .paleYellow
        let deleteNotification = UIBarButtonItem(title: "Delete Reminder", style: .plain, target: self, action: #selector(tappedDeleteReminder))
        deleteNotification.image = deleteReminderImage
        deleteNotification.tintColor = .paleYellow
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        doneButton.tintColor = .paleYellow
        toolBar.setItems([cancel,flexible,deleteNotification,flexible,doneButton], animated: false)
        toolBar.barTintColor = .blueSapphire
        self.inputAccessoryView = toolBar
    }
    
    @objc func tappedDeleteReminder() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        text = ""
        self.resignFirstResponder()
    }
    
    @objc func tappedCancel() {
        self.resignFirstResponder()
    }
    
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 7, y: 3, width: 20, height: 20))
        iconView.image = image
        iconView.tintColor = .blueSapphire
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
}
