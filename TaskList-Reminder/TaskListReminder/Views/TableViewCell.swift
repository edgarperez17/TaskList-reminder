//
//  TableViewCell.swift
//  TaskListReminder
//
//  Created by Tyler Schwartzman on 4/23/20.
//  Copyright © 2020 Tyler_Dev. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var task: Task? {
        didSet {
            taskLabel.text = task?.text
        }
    }
    
    var taskHeightConstraint: NSLayoutConstraint!
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blueSapphire
        label.tintColor = .blueSapphire
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        contentView.addSubview(taskLabel)
                    
        backgroundColor = .paleYellow
        tintColor = .blueSapphire
        
        taskLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        taskLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        taskLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        taskLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        taskHeightConstraint = taskLabel.heightAnchor.constraint(equalToConstant: 50)

        taskHeightConstraint.priority = UILayoutPriority.init(999)

        taskHeightConstraint.isActive = true

        taskLabel.numberOfLines = 0
        
    }
    
}
