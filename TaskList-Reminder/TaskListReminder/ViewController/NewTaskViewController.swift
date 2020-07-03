//
//  NewTaskVC.swift
//  TaskListReminder
//
//  Created by Tyler Schwartzman on 4/23/20.
//  Copyright © 2020 Tyler_Dev. All rights reserved.
//

import UIKit
import CoreData

protocol NewTaskViewControllerDelegate {
    func didAddTask(task: Task)
    func didEditTask(task: Task)
}

class NewTaskViewController: UIViewController {
    
    var delegate: NewTaskViewControllerDelegate?
    var taskTextField = TaskTextField()
    
    var task: Task? {
        didSet {
            taskTextField.text = task?.text
        }
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        navigationItem.title = "Add Task"
        configureBarButtons()
        createDismissKeyboardTap()
        
        view.backgroundColor = .paleYellow
    }
    
    //MARK: Save Task & Changes
    @objc private func tappedSaveTask() {
        if task == nil {
            tappedSaveTaskButton()
        } else {
            saveTaskEdit()
        }
    }
    
    private func saveTaskEdit() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        task?.text = taskTextField.text
        
        do {
            try context.save()
            
            // save succeeded
            navigationController?.popViewController(animated: true, completion: {
                self.delegate?.didEditTask(task: self.task!)
            })
            
        } catch let saveErr {
            print("Failed to save task changes:", saveErr)
        }
    }
    
    private func tappedSaveTaskButton() {
        
        // initialization of Core Data stack
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        guard let taskText = taskTextField.text else { return }
        
        if taskText.isEmpty {
            showError(title: "Empty Task", message: "You have not entered a task.")
            return
        }
        
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context)
        
        task.setValue(taskTextField.text, forKey: "text")
        
        // perform the save
        do {
            try context.save()
            
            //success
            navigationController?.popViewController(animated: true, completion: {
                self.delegate?.didAddTask(task: task as! Task)
            })
            
        } catch let saveErr {
            print("Failed to save task:", saveErr)
        }
    }
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func createDismissKeyboardTap(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func configureTextField() {
        view.addSubview(taskTextField)
        
        taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        taskTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        taskTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        taskTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        taskTextField.delegate = self
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tappedCancelButton))
        navigationItem.leftBarButtonItem?.tintColor = .blueSapphire
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save Task", style: .plain, target: self, action: #selector(tappedSaveTask))
        navigationItem.rightBarButtonItem?.tintColor = .blueSapphire
    }
    
    @objc private func tappedCancelButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension NewTaskViewController: UITextFieldDelegate {
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return false
    }
}
