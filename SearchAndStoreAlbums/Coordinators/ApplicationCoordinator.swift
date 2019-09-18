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
        #warning("implement LocalAlbumsController inject it")
        var albums: [Album] = []
        if let cdAlbums = persister.fetchAllAlbums() {
            albums = persister.map(cdAlbums: cdAlbums)
        }
        let localAlbumsViewController = LocalAlbumsViewController(albums: albums)
        localAlbumsViewController.delegate = self
        rootOut(with:localAlbumsViewController)
    }
    
    private func startAlbumSearchFlow() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        let albumSearchCoordinator = AlbumSearchCoordinator(artistNameCapable: networkingService, parserService: parserService, rootViewController: rootViewController)
        albumSearchCoordinator.delegate = self
        add(childCoordinator: albumSearchCoordinator)
        albumSearchCoordinator.start()
    }
    
    private func startDetailedInfoCoordinator(forArtist artist: Artist) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        let detailedInfoCoordinator = DetailedInfoCoordinator(networkingService: networkingService, parserService: parserService, persister: persister, rootViewController: rootViewController)
        detailedInfoCoordinator.delegate = self
        add(childCoordinator: detailedInfoCoordinator)
        detailedInfoCoordinator.start(withFlow: .AlbumsList(artist: artist))
    }
    
    private func startDetailedInfoCoordinator(forAlbum album: Album) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        let detailedInfoCoordinator = DetailedInfoCoordinator(networkingService: networkingService, parserService: parserService, persister: persister, rootViewController: rootViewController)
        detailedInfoCoordinator.delegate = self
        add(childCoordinator: detailedInfoCoordinator)
        detailedInfoCoordinator.start(withFlow: .AlbumDetail(album: album))
    }
    
    #warning("when button save pressed reflect to saved")
    #warning("update main view with saved albbums immidiately")
    #warning("change seaqrch for artist to magnifinig glass icon and use defaulot back button")
    #warning("implmet nav bar")
}

extension ApplicationCoordinator: LocalAlbumsViewControllerDelegate {
    
    // MARK: - LocalAlbumsViewControllerDelegate
    
    func didRequestToSearchForArtists(_ in: LocalAlbumsViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        pop()
        startAlbumSearchFlow()
    }
    
    func didSelect(album: Album, in localAlbumsViewController: LocalAlbumsViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        pop()
        startDetailedInfoCoordinator(forAlbum: album)
    }
}

extension ApplicationCoordinator: AlbumSearchCoordinatorDelegate {
    
    // MARK: - AlbumSearchCoordinatorDelegate
    
    func didFinish(withArtist artist: Artist?, in albumSearchCoordinator: AlbumSearchCoordinator) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        remove(childCoordinator: albumSearchCoordinator)
        if let artist = artist {
            startDetailedInfoCoordinator(forArtist: artist)
        }
    }
}

extension ApplicationCoordinator: DetailedInfoCoordinatorDelegate {
    
    // MARK: - DetailedInfoCoordinatorDelegate
    
    func didFinish(_ detailedInfoCoordinator: DetailedInfoCoordinator) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        remove(childCoordinator: detailedInfoCoordinator)
    }
    
    func shoudContinue(toArtistSearch: Bool, detailedInfoCoordinator: DetailedInfoCoordinator) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        remove(childCoordinator: detailedInfoCoordinator)
        startAlbumSearchFlow()
    }
    
    
    
}
