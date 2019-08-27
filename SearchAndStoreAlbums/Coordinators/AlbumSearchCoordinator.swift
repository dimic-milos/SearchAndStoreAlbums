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
    
    private let networkingService: NetworkingService
    private let parserService: ParserService
    
    weak var delegate: AlbumSearchCoordinatorDelegate?
    
    // MARK: - Init methods
    
    init(networkingService: NetworkingService, parserService: ParserService, rootViewController: UINavigationController) {
        os_log(.info, log: .initialization, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        self.networkingService = networkingService
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
        delegate?.didFinish(self)
    }
    
    func didTapSearch(forText searchText: String, _ artistSearchViewController: ArtistSearchViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        networkingService.getAllArtists(withName: searchText) { [weak self] (response) in
            guard let self = self else {
                os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                return
            }
            
            switch response.success {
                
            case true:
//                self.parserService
            case false:
                os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                return
            }
        }
    }
    
    func didSelect(artist: Artist, in artistSearchViewController: ArtistSearchViewController) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

    }
    
    
}
