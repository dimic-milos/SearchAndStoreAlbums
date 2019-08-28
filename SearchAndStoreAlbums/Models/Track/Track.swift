//
//  Track.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/28/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os

struct Track: Decodable {
    
    private enum CodingKeys: CodingKey {
        case name
    }
    
    let name: String
    
    init(from decoder: Decoder) throws {
        os_log(.info, log: .codable, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
    
    init(name: String) {
        self.name = name
    }
}
