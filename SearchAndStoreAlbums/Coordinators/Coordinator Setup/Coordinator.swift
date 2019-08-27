//
//  Coordinator.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

class Coordinator<T: UIViewController>: UIResponder, Coordinating {
    
    // MARK: - Properties
    
    let rootViewController: T
    var childCoordinators: [String : Coordinating] = [:]
    
    weak var parent: Coordinating?
    
    var identifier: String {
        return String(describing: type(of: self))
    }
    
    // MARK: - Init methods
    
    init(rootViewController: T) {
        os_log(.info, log: .initialization, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        self.rootViewController = rootViewController
        super.init()
    }
    
    // MARK: - Public methods
    
    func start() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
    }
    
    func finish() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
    }
    
    func add(childCoordinator coordinator: Coordinating) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.parent = self
    }
    
    func remove(childCoordinator coordinator: Coordinating) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        coordinator.parent = nil
        childCoordinators.removeValue(forKey: coordinator.identifier)
    }
    
    func removeAllChildCoordinators() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        for k in childCoordinators.keys {
            if let coordinator = childCoordinators[k] {
                coordinator.parent = nil
                childCoordinators.removeValue(forKey: coordinator.identifier)
            }
        }
    }
    
    func onLogout() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        parent?.onLogout()
    }
}
