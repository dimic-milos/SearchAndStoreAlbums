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
    private let persister: Persister

    weak var delegate: DetailedInfoCoordinatorDelegate?
    
    // MARK: - Init methods
    
    init(networkingService: NetworkingService, parserService: ParserService, persister: Persister, rootViewController: UINavigationController) {
        os_log(.info, log: .initialization, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        self.networkingService = networkingService
        self.parserService = parserService
        self.persister = persister
        super.init(rootViewController: rootViewController)
    }
    
    // MARK: - Public methods
    
    func start(withFlow flow: Flow) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        switch flow {
            
        case .AlbumDetail(let album):
            showAlbumDetailViewController(withAlbum: album)
        case .AlbumsList(let artist):
            getTopAlbums(byArtist: artist)
        }
    }
    
    // MARK: - Private methods
    
    private func showAlbumDetailViewController(withAlbum album: Album) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let albumDetailViewController = AlbumDetailViewController(album: album)
        albumDetailViewController.delegate = self
        show(albumDetailViewController)
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
    
    private func getTracks(forAlbum album: Album, artist artistName: String) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        networkingService.getTracks(forAlbum: album.name, artistName: artistName) { [weak self] (response) in
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
                    var selectedAlbum = album
                    selectedAlbum.tracks = tracks
                    self.showAlbumDetailViewController(withAlbum: selectedAlbum)
                case .failure(_):
                    break
                }
            case false:
                os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                return
            }
        }
    }
    
    
    private func insertAlbum(withName albumName: String, artistName: String, tracks: [String], image: [String]) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        _ = persister.insertAlbum(withName: albumName, artistName: artistName, tracks: tracks, image: image)
    }
    
    private func deleteAlbum(withName albumName: String) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        _ = persister.deleteAlbum(withName: albumName)
    }
    
    
}

extension DetailedInfoCoordinator: AlbumsListViewControllerDelegate {
    
    // MARK: - AlbumsListViewControllerDelegate
    
    func showInDetail(album: Album, artistName: String, albumsListViewController: AlbumsListViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        pop()
        getTracks(forAlbum: album, artist: artistName)
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

extension DetailedInfoCoordinator: AlbumDetailViewControllerDelegate {
    
    // MARK: - AlbumDetailViewControllerDelegate
    
    func store(album: Album, albumDetailViewController: AlbumDetailViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        insertAlbum(withName: album.name, artistName: album.artist.name, tracks: album.tracks.map { $0.name }, image: album.image.map { $0.imageUrl} )
    }
    
    func delete(album: Album, albumDetailViewController: AlbumDetailViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        deleteAlbum(withName: album.name)
    }
    
    func didTapBack(_ albumDetailViewController: AlbumDetailViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        pop()
        delegate?.didFinish(self)
    }
    
    func didTapSearchForArtists(_ albumDetailViewController: AlbumDetailViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        pop()
        delegate?.shoudContinue(toArtistSearch: true, detailedInfoCoordinator: self)
    }
}
