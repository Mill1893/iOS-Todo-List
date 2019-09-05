//
//  Task.swift
//  iOSProject
//
//  Created by Andrew Miller on 4/12/18.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding {
    
    var name: String?
    var isDone: Bool?
    var labels: Array<String>?
    
    private let nameKey = "name"
    private let isDoneKey = "isDone"
    
    init(name: String, isDone: Bool = false, labels: Array<String> = []) {
        self.name = name
        self.isDone = isDone
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(isDone, forKey: isDoneKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        guard let name = aDecoder.decodeObject(forKey: nameKey) as? String,
              let isDone = aDecoder.decodeObject(forKey: isDoneKey) as? Bool
              else { return }
        
        self.name = name
        self.isDone = isDone
    }
    
}
