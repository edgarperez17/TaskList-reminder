//
//  UserDefaults+Ext.swift
//  TaskListReminder
//
//  Created by Tyler Schwartzman on 5/27/20.
//  Copyright © 2020 Tyler_Dev. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        
        var colorData: NSData?
        if let color = color {
            colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true) as NSData?
        }
        set(colorData, forKey: key)
    }
}
