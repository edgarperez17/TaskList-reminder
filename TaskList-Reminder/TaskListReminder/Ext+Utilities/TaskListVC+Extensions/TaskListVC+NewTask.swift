//
//  TaskListVC+NewTask.swift
//  TaskListReminder
//
//  Created by Tyler Schwartzman on 4/23/20.
//  Copyright © 2020 Tyler_Dev. All rights reserved.
//

import UIKit

extension TaskListViewController: NewTaskViewControllerDelegate {
    
    func didEditTask(task: Task) {
        let row = tasks.firstIndex(of: task)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    func didAddTask(task: Task) {
        tasks.append(task)
        let newIndexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
}
