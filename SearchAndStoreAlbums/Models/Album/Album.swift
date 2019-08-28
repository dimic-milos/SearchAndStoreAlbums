//
//  Album.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//
import os

struct Album: Decodable {
    
    private enum CodingKeys: CodingKey {
        case name
        case artist
        case image
        case tracks
    }
    
    let name: String
    let artist: Artist
    let image: [AlbumImage]
    
    var tracks: [Track] = []
    var isPersisted = false
    
    init(from decoder: Decoder) throws {
        os_log(.info, log: .codable, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        artist = try container.decode(Artist.self, forKey: .artist)
        image = try container.decode([AlbumImage].self, forKey: .image)
    }
    
    init(name: String, artistName: String, tracks: [Track], image: [AlbumImage], isPersisted: Bool) {
        self.name = name
        self.artist = Artist(name: artistName)
        self.isPersisted = isPersisted
        self.tracks = tracks
        self.image = image
    }
}

