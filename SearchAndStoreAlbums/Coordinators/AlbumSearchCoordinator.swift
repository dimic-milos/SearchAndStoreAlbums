//
//  AlbumSearchCoordinator.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

class AlbumSearchCoordinator: NavigationCoordinator {
    
    // MARK: - Properties
    
    private let artistNameCapable: ArtistNameCapable
    private let parserService: ParserService
    
    weak var delegate: AlbumSearchCoordinatorDelegate?
    
    // MARK: - Init methods
    
    init(artistNameCapable: ArtistNameCapable, parserService: ParserService, rootViewController: UINavigationController) {
        os_log(.info, log: .initialization, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        self.artistNameCapable = artistNameCapable
        self.parserService = parserService
        super.init(rootViewController: rootViewController)
    }
    
    // MARK: - Override methods
    
    override func start() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        startArtistSearchViewController()
    }
    
    // MARK: - Private methods
    
    private func startArtistSearchViewController() {
        let artistSearchViewController = ArtistSearchViewController()
        artistSearchViewController.delegate = self
        present(artistSearchViewController)
    }
}

extension AlbumSearchCoordinator: ArtistSearchViewControllerDelegate {
    
    //  MARK: - ArtistSearchViewControllerDelegate
    
    func didTapSearchBarCancelButton(in artistSearchViewController: ArtistSearchViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        dismiss()
        delegate?.didFinish(withArtist: nil, in: self)
    }
    
    func didTapSearch(forText searchText: String, _ artistSearchViewController: ArtistSearchViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        artistNameCapable.getAllArtists(withName: searchText) { [weak self] (response) in
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
                let parseResult = self.parserService.parseArtists(fromData: data)
                
                switch parseResult {
                    
                case .success(let artists):
                    artistSearchViewController.reload(withArtists: artists)
                case .failure(_):
                    break
                }
            case false:
                os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                return
            }
        }
    }
    
    func didSelect(artist: Artist, in artistSearchViewController: ArtistSearchViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        dismiss()
        delegate?.didFinish(withArtist: artist, in: self)
    }
    
    
}

