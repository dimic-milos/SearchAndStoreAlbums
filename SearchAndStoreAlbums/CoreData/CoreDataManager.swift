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
    
    func fetchAllAlbums() -> [CDAlbum]? {
        os_log(.info, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDAlbum")

        do {
            let albums = try managedContext.fetch(fetchRequest)
            return albums as? [CDAlbum]
        } catch {
            os_log(.error, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
            return nil
        }
    }

    func insertAlbum(withName name: String, artistName: String, tracks: [String],  image: [String]) -> CDAlbum? {
        os_log(.info, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        let managedContext = persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "CDAlbum", in: managedContext)!
        let persistedAlbum = NSManagedObject(entity: entity, insertInto: managedContext)

        persistedAlbum.setValue(name, forKeyPath: "name")
        persistedAlbum.setValue(artistName, forKeyPath: "artist")
        persistedAlbum.setValue(tracks, forKeyPath: "tracks")
        persistedAlbum.setValue(image, forKeyPath: "image")

        do {
            try managedContext.save()
            return persistedAlbum as? CDAlbum
        } catch {
            os_log(.error, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
            fatalError()
        }
    }
    
    func deleteAlbum(withName albumName: String) -> [CDAlbum]? {
        os_log(.info, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDAlbum")
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", albumName)
        do {
            let albums = try managedContext.fetch(fetchRequest)
            var deletedAlbums: [CDAlbum] = []
            
            for album in albums {
                managedContext.delete(album)
                try managedContext.save()
                deletedAlbums.append(album as! CDAlbum)
            }
            return deletedAlbums
        } catch {
            os_log(.error, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
            return nil
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
