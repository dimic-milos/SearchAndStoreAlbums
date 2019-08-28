//
//  DetailedInfoCoordinatorDelegate.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/28/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

protocol DetailedInfoCoordinatorDelegate: class {
    func didFinish(_ detailedInfoCoordinator: DetailedInfoCoordinator)
    func shoudContinue(toArtistSearch: Bool, detailedInfoCoordinator: DetailedInfoCoordinator)
}
