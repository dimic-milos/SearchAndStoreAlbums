//
//  CoreDataManager.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import CoreData

class CoreDataManager: Persister {
    
    // MARK: - Properties
    
    private let container = NSPersistentContainer(name: "SearchAndStoreAlbums")
    
    private lazy var persistentContainer: NSPersistentContainer = {
        os_log(.info, log: .database, "computedProperty: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        loadPeristentStores()
        return container
    }()
    
    // MARK: - Init methods
    
    init() {
        os_log(.info, log: .initialization, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
    }
    // MARK: Public methods
    
    func saveContext () {
        os_log(.info, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                os_log(.error, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
            }
        }
    }

    // MARK: - Private methods
    
    private func loadPeristentStores() {
        os_log(.info, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let _ = error {
                os_log(.error, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
            }
        })
    }
}
