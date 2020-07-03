//
//  CoreDataManager.swift
//  TaskListReminder
//
//  Created by Tyler Schwartzman on 4/23/20.
//  Copyright © 2020 Tyler_Dev. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchTasks() -> [Task] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        } catch let fetchErr {
            print("Failed to fetch tasks:", fetchErr)
            return []
        }
    }    
}
