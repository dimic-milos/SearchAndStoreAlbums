//
//  LocalAlbumsViewControllerDelegate.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

protocol LocalAlbumsViewControllerDelegate: class {
    func didRequestToSearchForArtists(_ in: LocalAlbumsViewController)
    func didSelect(album: Album, in localAlbumsViewController: LocalAlbumsViewController)
    func viewWillAppear(in localAlbumsViewController: LocalAlbumsViewController)
}
