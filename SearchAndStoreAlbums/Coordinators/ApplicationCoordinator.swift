//
//  ApplicationCoordinator.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

class ApplicationCoordinator: NavigationCoordinator {
    
    // MARK: - Properties
    
    private let window: UIWindow
    private let networkingService: NetworkingService
    private let parserService: ParserService
    private let persister: Persister
    
    // MARK: - Init methods
    
    init(window: UIWindow, networkingService: NetworkingService, parserService: ParserService, persister: Persister, rootViewController: UINavigationController) {
        os_log(.info, log: .initialization, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        self.window = window
        self.networkingService = networkingService
        self.parserService = parserService
        self.persister = persister
        super.init(rootViewController: rootViewController)
    }
    
    // MARK: - Override methods
    
    override func start() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        window.set(rootViewController: rootViewController)
        rootViewController.setNavigationBarHidden(true, animated: false)
        showOfflineAlbums()
    }
    
    // MARK: - Private methods
    
    private func showOfflineAlbums() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let localAlbumsViewController = LocalAlbumsViewController()
        localAlbumsViewController.delegate = self
        rootOut(with:localAlbumsViewController)
    }
    
    private func startAlbumSearchFlow() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        let albumSearchCoordinator = AlbumSearchCoordinator(networkingService: networkingService, parserService: parserService, rootViewController: rootViewController)
        albumSearchCoordinator.delegate = self
        add(childCoordinator: albumSearchCoordinator)
        albumSearchCoordinator.start()
    }
}

extension ApplicationCoordinator: LocalAlbumsViewControllerDelegate {
    
    // MARK: - LocalAlbumsViewControllerDelegate
    
    func didRequestToSearchForArtists(_ in: LocalAlbumsViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        pop()
        startAlbumSearchFlow()
        
    }
}

extension ApplicationCoordinator: AlbumSearchCoordinatorDelegate {
    
    // MARK: - AlbumSearchCoordinatorDelegate
    
    func didFinish(_ albumSearchCoordinator: AlbumSearchCoordinator) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        remove(childCoordinator: albumSearchCoordinator)
    }
    
    
}
