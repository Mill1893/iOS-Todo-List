//
//  TaskUtility.swift
//  iOSProject
//
//  Created by Andrew Miller on 4/13/18.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import Foundation

class TaskUtility {
    
    private static let key = "tasks"
    
    // Archive
    private static func archive(_ tasks: [[Task]]) -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: tasks) as NSData
    }
    
    // Fetch
    static func fetch() -> [[Task]]? {
        guard let unarchivedData = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        
        return NSKeyedUnarchiver.unarchiveObject(with: unarchivedData) as? [[Task]]
    }
    
    // Save
    static func save(_ tasks: [[Task]]) {
        
        // Archive
        let archivedTasks = archive(tasks)
        
        // Set object for key
        UserDefaults.standard.set(archivedTasks, forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
    
}
