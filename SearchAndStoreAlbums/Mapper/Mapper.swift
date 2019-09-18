//
//  Mapper.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 9/18/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//
import os
import Foundation

class Mapper {
    
    class func map(cdAlbums: [CDAlbum]) -> [Album] {
        os_log(.info, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
//        #warning("extract to proper object")
        var albums: [Album] = []
        cdAlbums.forEach {
            guard let albumName = $0.name else {
                os_log(.error, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                return
            }
            guard let artistName = $0.artist else {
                os_log(.error, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                return
            }
            guard let tracks = $0.tracks as? [String] else {
                os_log(.error, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                return
            }
            guard let image = $0.image as? [String] else {
                os_log(.error, log: .database, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
                return
            }
            
            let album = Album(name: albumName, artistName: artistName, tracks: tracks.map { Track(name: $0) }, image: image.map { AlbumImage(imageUrl: $0) }, isPersisted: true)
            albums.append(album)
        }
        return albums
    }
}
