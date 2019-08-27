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
    
    private struct Response: Decodable {
        let results: Results
    }
    
    private struct Results: Decodable {
        let artistmatches: ArtistMatches
    }
    
    private struct ArtistMatches: Decodable {
        let artist: [Artist]
    }
    
    // MARK: - Public methods
    
    func parseArtists(fromData data: Data) -> (Result<[Artist], Error>) {
        os_log(.info, log: .parser, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        do {
            let response = try JSONDecoder.init().decode(Response.self, from: data)
            return .success(response.results.artistmatches.artist)
        } catch {
            os_log(.error, log: .parser, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
            return .failure(error)
        }
    }
}
