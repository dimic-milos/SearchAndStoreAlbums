//
//  Album.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os

struct AlbumImage: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case imageUrl = "#text"
        case size
    }
    
    let imageUrl: String
    let size: String
    
    init(from decoder: Decoder) throws {
        os_log(.info, log: .codable, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        size = try container.decode(String.self, forKey: .size)
    }
}

struct Album: Decodable {
    
    private enum CodingKeys: CodingKey {
        case name
        case artist
        case image
    }
    
    let name: String
    let artist: Artist
    let image: [AlbumImage]
    
    init(from decoder: Decoder) throws {
        os_log(.info, log: .codable, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        artist = try container.decode(Artist.self, forKey: .artist)
        image = try container.decode([AlbumImage].self, forKey: .image)

    }
}

