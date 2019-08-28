//
//  ParserService.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//
import os
import Foundation

class ParserService {
    
    // MARK: - Public methods
    
    func parseArtists(fromData data: Data) -> (Result<[Artist], Error>) {
        os_log(.info, log: .parser, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        do {
            let response = try JSONDecoder.init().decode(ArtistSearch.self, from: data)
            return .success(response.results.artistmatches.artist)
        } catch {
            os_log(.error, log: .parser, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
            return .failure(error)
        }
    }
    
    func parseAlbums(fromData data: Data) -> (Result<[Album], Error>) {
        os_log(.info, log: .parser, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        do {
            let response = try JSONDecoder.init().decode(TopAlbumsSearch.self, from: data)
            return .success(response.topalbums.album)
        } catch {
            os_log(.error, log: .parser, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
            return .failure(error)
        }
    }
}

extension ParserService {
    
    private struct ArtistSearch: Decodable {
        let results: Results
    }
    
    private struct Results: Decodable {
        let artistmatches: ArtistMatches
    }
    
    private struct ArtistMatches: Decodable {
        let artist: [Artist]
    }
}

extension ParserService {
    
    private struct TopAlbumsSearch: Decodable {
        let topalbums: AlbumSearch
    }
    
    private struct AlbumSearch: Decodable {
        let album: [Album]
    }
    
}
