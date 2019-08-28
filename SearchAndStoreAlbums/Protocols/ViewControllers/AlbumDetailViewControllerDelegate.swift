//
//  AlbumDetailViewControllerDelegate.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/28/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

protocol AlbumDetailViewControllerDelegate: class {
    func store(album: Album, albumDetailViewController: AlbumDetailViewController)
    func delete(album: Album, albumDetailViewController: AlbumDetailViewController)
    func didTapBack(_ albumDetailViewController: AlbumDetailViewController)
    func didTapSearchForArtists(_ albumDetailViewController: AlbumDetailViewController)
}
