//
//  ArtistSearchViewControllerDelegate.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

protocol ArtistSearchViewControllerDelegate: class {
    func didTapSearchBarCancelButton(in artistSearchViewController: ArtistSearchViewController)
    func didTapSearch(forText searchText: String, _ artistSearchViewController: ArtistSearchViewController)
    func didSelect(artist: Artist, in artistSearchViewController: ArtistSearchViewController)
}
