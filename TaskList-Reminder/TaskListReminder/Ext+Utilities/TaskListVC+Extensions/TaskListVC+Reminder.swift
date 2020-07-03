//
//  TaskListVC+ReminderView.swift
//  TaskListReminder
//
//  Created by Tyler Schwartzman on 6/12/20.
//  Copyright © 2020 Tyler_Dev. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard

extension TaskListViewController: UITextFieldDelegate, UNUserNotificationCenterDelegate {
    
    struct Keys {
        static let reminderText = "reminderText"
        static let reminderColor = "reminderColor"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showReminderInputView(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showReminderInputView(true)
    }
    
    /// Show or hide the image from NavBar while going to next screen or back to initial screen
   func showReminderInputView(_ show: Bool) {
        self.reminderInputView.alpha = show ? 1.0 : 0.0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    self.reminderInputView.becomeFirstResponder()
                }
            } else {
                DispatchQueue.main.async {
                    self.reminderInputView.resignFirstResponder()
                }
            }
        }
    }
    
    @objc func scheduleNotification(at date: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = "Task List"
        content.body = "Time to complete your Tasks!"
        content.sound = UNNotificationSound.default
        
        let calander = Calendar(identifier: .gregorian)
        let components = calander.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calander, timeZone: .current,  month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in if let error = error {
            print("We had an error:\(error)")
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ], completionHandler: {didAllow, error in })
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveReminderText()
    }

    func saveReminderText() {
        defaults.set(reminderInputView.text!, forKey: Keys.reminderText)
        defaults.setColor(color: .blueSapphire, forKey: Keys.reminderColor)
    }
    
    func checkForSavedReminder() {
        let reminderText = defaults.value(forKey: Keys.reminderText) as? String ?? ""
        reminderInputView.text = reminderText
        let textColor = defaults.colorForKey(key: Keys.reminderColor)
        reminderInputView.textColor = textColor
    }
    
}
