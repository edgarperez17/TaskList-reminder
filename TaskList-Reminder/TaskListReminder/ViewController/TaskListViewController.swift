//
//  TaskListVC.swift
//  TaskListReminder
//
//  Created by Tyler Schwartzman on 4/23/20.
//  Copyright © 2020 Tyler_Dev. All rights reserved.
//

import UserNotifications
import UIKit
import CoreData


class TaskListViewController: UIViewController {
        
    let reminderInputView = UITextField()
    
    var tasks = [Task]()
    var tableView = UITableView()
    
    let reminderImage = UIImage(systemName: "alarm")
    let newTaskImage = UIImage(systemName: "pencil")
    let deleteAllImage = UIImage(systemName: "trash")
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tasks = CoreDataManager.shared.fetchTasks()
        configureBarButtons()
        setupNavBarAndReminderInput()
        configureTableView()
        checkForSavedReminder()
    }
    
    private func setupNavBarAndReminderInput() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Task List"
        
        configureDatePickerInputView()
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(reminderInputView)
        reminderInputView.delegate = self
        reminderInputView.tintColor = UIColor.blueSapphire
        reminderInputView.setIcon(reminderImage!)
        reminderInputView.attributedPlaceholder = NSAttributedString(string:"Reminder", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueSapphire])
        reminderInputView.layer.cornerRadius = Constants.InputViewHeight / 2
        reminderInputView.clipsToBounds = true
        
        reminderInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reminderInputView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Constants.InputViewRightMargin),
            reminderInputView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Constants.InputViewBottomMargin),
            reminderInputView.heightAnchor.constraint(equalToConstant: Constants.InputViewHeight),
            reminderInputView.widthAnchor.constraint(equalToConstant: Constants.InputViewWidth)
        ])
    }
    
    private func configureDatePickerInputView() {
        self.reminderInputView.setInputViewDatePicker(target: self, selector: #selector(tappedReminderDone))
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .paleYellow
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(TableViewCell.self, forCellReuseIdentifier: Cells.cellID)
        tableView.pin(to: view)
        tableView.reloadData()
    }
    
    @objc private func tappedReminderDone() {
        if let datePicker = self.reminderInputView.inputView as? UIDatePicker {
            scheduleNotification(at: datePicker.date)
            let dateformatter = DateFormatter()
            dateformatter.timeStyle = .short
            self.reminderInputView.text = dateformatter.string(from: datePicker.date)
            self.reminderInputView.textColor = .blueSapphire
        }
        self.reminderInputView.resignFirstResponder()
    }
    
    //MARK: BarButtons & Functions
    private func configureBarButtons() {
        
        let deleteAll = UIBarButtonItem()
        deleteAll.image = deleteAllImage
        deleteAll.tintColor = .blueSapphire
        deleteAll.target = self
        deleteAll.action = #selector(tappedDeleteAllButton)
        
        let newTaskButton = UIBarButtonItem()
        newTaskButton.image = newTaskImage
        newTaskButton.tintColor = .blueSapphire
        newTaskButton.target = self
        newTaskButton.action = #selector(tappedNewTaskButton)
        
        navigationItem.leftBarButtonItem = deleteAll
        navigationItem.rightBarButtonItem = newTaskButton
    }
    
    @objc private func tappedDeleteAllButton(_ sender: UIBarButtonItem) {
        
        showDeleteAllAlert(title: "This will delete all Tasks in your Task List.",
                           message: "Are you sure you want to do this?")
    }
    
    @objc private func tappedNewTaskButton(_ sender: UIBarButtonItem) {
        let newTaskVC = NewTaskViewController()
        newTaskVC.delegate = self
        navigationController?.pushViewController(newTaskVC, animated: true)
    }
    
    private func showDeleteAllAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Task.fetchRequest())
            
            do {
                try context.execute(batchDeleteRequest)
                
                // upon deletion from core data succeeded
                
                var indexPathsToRemove = [IndexPath]()
                
                for (index, _) in self.tasks.enumerated() {
                    let indexPath = IndexPath(row: index, section: 0)
                    indexPathsToRemove.append(indexPath)
                }
                self.tasks.removeAll()
                self.tableView.deleteRows(at: indexPathsToRemove, with: .left)
                
            } catch let delErr {
                print("Failed to delete objects from Core Data:", delErr)
            }} ))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
