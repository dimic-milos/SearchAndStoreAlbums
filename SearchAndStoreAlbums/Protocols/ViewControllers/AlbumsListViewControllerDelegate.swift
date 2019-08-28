//
//  AlbumsListViewControllerDelegate.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/28/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

protocol AlbumsListViewControllerDelegate: class {
    func store(album: Album, albumsListViewController: AlbumsListViewController)
    func delete(album: Album, albumsListViewController: AlbumsListViewController)
    func didTapBack(_ albumsListViewController: AlbumsListViewController)

}
