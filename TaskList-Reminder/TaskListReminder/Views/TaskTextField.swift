//
//  TaskTextField.swift
//  TaskListReminder
//
//  Created by Tyler Schwartzman on 4/23/20.
//  Copyright © 2020 Tyler_Dev. All rights reserved.
//

import UIKit

class TaskTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextField() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.blueSapphire.cgColor
        textColor = .blueSapphire
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        backgroundColor = .paleYellow
        keyboardType = .default
        returnKeyType = .done
        attributedPlaceholder = NSAttributedString(string:"Add Task", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueSapphire])
        font = .preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
    }
}
