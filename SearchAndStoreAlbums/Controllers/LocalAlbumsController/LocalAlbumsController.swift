//
//  LocalAlbumsController.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 9/18/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import Foundation

class LocalAlbumsController {
    
    private let persister: Persister
    
    init(persister: Persister) {
        self.persister = persister
    }
    
    func getOfflineAlbums() -> [Album] {
        var albums: [Album] = []
        if let cdAlbums = persister.fetchAllAlbums() {
            albums = Mapper.map(cdAlbums: cdAlbums)
        }
        return albums
    }
}
