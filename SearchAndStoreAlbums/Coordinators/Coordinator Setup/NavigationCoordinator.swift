//
//  NavigationCoordinator.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

class NavigationCoordinator: Coordinator<UINavigationController> {
    
    // MARK: - Properties
    
    var viewControllers = [UIViewController]()
    
    // MARK: - Public methods
    
    func rootOut(with vc: UIViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        viewControllers = [vc]
        rootViewController.viewControllers = [vc]
    }
    
    func show(_ vc: UIViewController, sender: Any = self) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        viewControllers.append(vc)
        rootViewController.show(vc, sender: sender)
    }
    
    func present(_ vc: UIViewController) {
        rootViewController.present(vc, animated: true, completion: nil)
    }
    
    func pop() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        if !viewControllers.isEmpty {
            viewControllers.removeLast()
            rootViewController.popViewController(animated: true)
        } else {
            os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        }
    }
    
    func dismiss() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        rootViewController.dismiss(animated: true, completion: nil)
    }
}
