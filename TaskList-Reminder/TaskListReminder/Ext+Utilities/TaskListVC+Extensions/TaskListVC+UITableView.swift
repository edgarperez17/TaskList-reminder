//
//  TableViewNewMethods.swift
//  TaskListReminder
//
//  Created by Tyler Schwartzman on 6/12/20.
//  Copyright © 2020 Tyler_Dev. All rights reserved.
//

import UIKit

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    struct Cells {
        static let cellID = "cellID"
    }
    
    internal func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let swipeActions = UISwipeActionsConfiguration(actions:
            [deleteHandlerFunction(forRowAt: indexPath),
             editHandlerFunction(forRowAt: indexPath)])
        
        return swipeActions
    }
    
    func editHandlerFunction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { (contextualAction: UIContextualAction, swipeButton: UIView, completionHandler: (Bool) -> Void) in
            
            let editTaskController = NewTaskViewController()
            editTaskController.delegate = self
            editTaskController.task = self.tasks[indexPath.row]
            self.navigationController?.pushViewController(editTaskController, animated: true)
        })
        editAction.backgroundColor = .blueSapphire
        return editAction
    }
    
    func deleteHandlerFunction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (contextualAction: UIContextualAction, swipeButton: UIView, completionHandler: (Bool) -> Void) in
            
            let task = self.tasks[indexPath.row]
            
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // delete the task from Core Data
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            context.delete(task)
            
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete company:", saveErr)
            }
        })
        deleteAction.backgroundColor = .lightRed
        return deleteAction
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .blueSapphire
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No Tasks"
        label.textColor = .blueSapphire
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tasks.count == 0 ? 150 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellID, for: indexPath) as! TableViewCell
        
        let task = tasks[indexPath.row]
        let taskStatus = task.value(forKey: "isChecked") as? Bool ?? false
        cell.textLabel?.text = task.value(forKey: "text") as? String
        cell.textLabel?.textColor = .blueSapphire
        
        var accessoryType = TableViewCell.AccessoryType.none
        
        if (taskStatus) {
            accessoryType = TableViewCell.AccessoryType.checkmark
        }
        
        cell.accessoryType = accessoryType
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let taskObject = tasks[indexPath.row]
        let taskStatus = taskObject.value(forKey: "isChecked") as? Bool ?? false
        
        taskObject.setValue(!taskStatus,forKey:"isChecked") // Toggle completed status
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Cannot save object: \(error), \(error.localizedDescription)")
        }
        
        tableView.deselectRow(at: indexPath,animated:false)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}
