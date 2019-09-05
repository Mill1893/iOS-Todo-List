//
//  TaskStore.swift
//  iOSProject
//
//  Created by Andrew Miller on 4/12/18.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import Foundation

class TaskStore {
    
    var tasks = [[Task](),[Task]()]
    
    func add(_ task: Task, at index: Int, isDone: Bool = false) {
        
        let section = isDone ? 1 : 0
        
        tasks[section].insert(task, at: index)
        
    }
    
    @discardableResult func removeTask(at index: Int, isDone: Bool = false) -> Task {
        
        let section = isDone ? 1 : 0
        
        return tasks[section].remove(at: index)
    }
}
