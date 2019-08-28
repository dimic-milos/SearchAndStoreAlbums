//
//  DetailedInfoCoordinator.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

class DetailedInfoCoordinator: NavigationCoordinator {
    
    enum Flow {
        case AlbumDetail(album: Album)
        case AlbumsList(artist: Artist)
    }
    
    // MARK: - Properties
    
    private let networkingService: NetworkingService
    private let parserService: ParserService
    
    weak var delegate: DetailedInfoCoordinatorDelegate?
    
    // MARK: - Init methods
    
    init(networkingService: NetworkingService, parserService: ParserService, rootViewController: UINavigationController) {
        os_log(.info, log: .initialization, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        self.networkingService = networkingService
        self.parserService = parserService
        super.init(rootViewController: rootViewController)
    }
    
    // MARK: - Public methods
    
    func start(withFlow flow: Flow) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        switch flow {
            
        case .AlbumDetail:
            break
        case .AlbumsList(let artist):
            getTopAlbums(byArtist: artist)
        }
    }
    
    // MARK: - Private methods
    
    private func showAlbumDetailViewController() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
    }
    

    
    private func showAlbumsListViewController(withAlbums albums: [Album]) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let albumsListViewController = AlbumsListViewController(albums: albums)
        albumsListViewController.delegate = self
        show(albumsListViewController)
    }
    
    private func getTopAlbums(byArtist artist: Artist) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        networkingService.getTopAlbums(byArtist: artist.name) { [weak self] (response) in
            guard let self = self else {
                os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                return
            }
            
            switch response.success {
                
            case true:
                guard let data = response.data else {
                    os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                    return
                }
                let parseResult = self.parserService.parseAlbums(fromData: data)
                
                switch parseResult {
                    
                case .success(let albums):
                    self.showAlbumsListViewController(withAlbums: albums)
                case .failure(_):
                    break
                }
            case false:
                os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                return
            }
        }
    }
    
    private func getTracks(forAlbum albumName: String, artist artistName: String) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        networkingService.getTracks(forAlbum: albumName, artistName: artistName) { [weak self] (response) in
            guard let self = self else {
                os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                return
            }
            
            switch response.success {
                
            case true:
                guard let data = response.data else {
                    os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                    return
                }
                let parseResult = self.parserService.parseTracks(fromData: data)
                
                switch parseResult {
                    
                case .success(let tracks):
                    print(tracks)
                case .failure(_):
                    break
                }
            case false:
                os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                return
            }
        }
    }
    
    
}

extension DetailedInfoCoordinator: AlbumsListViewControllerDelegate {
    
    // MARK: - AlbumsListViewControllerDelegate
    
    func showInDetail(album: Album, artistName: String, albumsListViewController: AlbumsListViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        getTracks(forAlbum: album.name, artist: artistName)
    }
    
    func store(album: Album, albumsListViewController: AlbumsListViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

    }
    
    func delete(album: Album, albumsListViewController: AlbumsListViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

    }

    func didTapBack(_ albumsListViewController: AlbumsListViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        pop()
        delegate?.didFinish(self)
    }
    
    func didTapSearchForArtists(_ albumsListViewController: AlbumsListViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        pop()
        delegate?.shoudContinue(toArtistSearch: true, detailedInfoCoordinator: self)
    }
    
}
