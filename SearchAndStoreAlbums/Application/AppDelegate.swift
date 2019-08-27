//
//  AppDelegate.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var applicationCoordinator: ApplicationCoordinator!
    let mainNavigationController = MainNavigationController()
    let coreDataManager = CoreDataManager()
    let networkService = NetworkingService()
    let parserService = ParserService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        applicationCoordinator = ApplicationCoordinator(window: window!, networkingService: networkService, parserService: parserService, persister: coreDataManager, rootViewController: mainNavigationController)
        applicationCoordinator.start()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataManager.saveContext()
    }
}

