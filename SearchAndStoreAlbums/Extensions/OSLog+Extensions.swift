//
//  OSLog+Extensions.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import Foundation

extension OSLog.Category {
    static let Initialization = "Initialization"
    static let Codable = "Codable"
    static let Sequence = "Sequence"
    static let UI = "UI"
    static let Action = "Action"
    static let Network = "Network"
    static let Database = "Database"
    static let Parser = "Parser"
    static let Location = "Location"
    static let User = "User"
    static let Alert = "Alert"
    static let Temp = "Temp"
}

extension OSLog {
    
    private static var subsystem =  Bundle.main.bundleIdentifier!
    private static var subsystemNoise = "NOISE"
    
    static let initialization = OSLog(subsystem: subsystem, category: Category.Initialization)
    static let sequence = OSLog(subsystem: subsystem, category: Category.Sequence)
    static let ui = OSLog(subsystem: subsystem, category: Category.UI)
    static let action = OSLog(subsystem: subsystem, category: Category.Action)
    static let network = OSLog(subsystem: subsystem, category: Category.Network)
    static let database = OSLog(subsystem: subsystem, category: Category.Database)
    static let parser = OSLog(subsystem: subsystem, category: Category.Parser)
    static let location = OSLog(subsystem: subsystem, category: Category.Location)
    static let user = OSLog(subsystem: subsystem, category: Category.User)
    static let alert = OSLog(subsystem: subsystem, category: Category.Alert)
    static let temp = OSLog(subsystem: subsystem, category: Category.Temp)
    
    // MARK: - Subsystem Noise
    
    static let frequent = OSLog(subsystem: subsystemNoise, category: Category.Sequence)
    static let codable = OSLog(subsystem: subsystemNoise, category: Category.Codable)
    
}

