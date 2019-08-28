//
//  Persister.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

protocol Persister {
    func fetchAllAlbums() -> [CDAlbum]?
    func insertAlbum(withName name: String, artistName: String, tracks: [String]) -> CDAlbum?
}
