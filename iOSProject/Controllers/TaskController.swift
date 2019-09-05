//
//  TaskController.swift
//  iOSProject
//
//  Created by Andrew Miller on 4/9/18.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit

class TaskController: UITableViewController {
    
    var taskStore: TaskStore! {
        didSet {
            // Get data
            taskStore.tasks = TaskUtility.fetch() ?? [[Task](), [Task]()]
            
            // Relaod table view
            tableView.reloadData()
        }
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
         super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func longPressTask(_ sender: Any) {
        //let alertController = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)
        
    }
    
    @IBAction func addTask(_ sender: Any) {
        // Setting up our alert controller
        
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        // Set up the actions
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            // Grab text field text
            guard let name = alertController.textFields?.first?.text else { return }
            
            // Create task
            let newTask = Task(name: name)
            
            // Add task
            self.taskStore.add(newTask, at: 0)
            
            // Reload data in table view
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
        }
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add the text field
        alertController.addTextField { textField in
            textField.placeholder = "Enter task name."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        
        // Add the actions
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        // Present
        present(alertController, animated: true)
    }
    
    @objc private func handleTextChanged(_ sender: UITextField) {
        guard let alertController = presentedViewController as? UIAlertController,
              let addAction = alertController.actions.first,
              let text = sender.text
              else { return }
        
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    
}

// MARK: - DataSource

extension TaskController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task_cell", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To-Do" : "Done"
    }
    
}

//MARK: - Delegate
extension TaskController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action , sourceView, completionHandler) in
            
            // Determine whether the task is done
            guard let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone else { return }
            
            // Remove task from array
            self.taskStore.removeTask(at: indexPath.row, isDone: isDone)
            
            // Reload table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            // Indicate action was done
            completionHandler(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1450980392, blue: 0.168627451, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completionHandler) in
            
            // Toggle that task is done
            self.taskStore.tasks[0][indexPath.row].isDone = true
            
            // Remove task from array containing todo items
            let doneTask = self.taskStore.removeTask(at: indexPath.row)
            
            // Reload table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Add task to array containing done tasks
            self.taskStore.add(doneTask, at: 0, isDone: true)
            
            // Reload table view
            tableView.insertRows(at: [IndexPath(row:0,section:1)], with: .automatic)
            
            
            // Indicate action was performed
            completionHandler(true)
        }
        
        doneAction.image = #imageLiteral(resourceName: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.7529411765, blue: 0.2901960784, alpha: 1)
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
    
}
