//
//  Coordinating.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

protocol Coordinating: class {
    
    var parent: Coordinating? { get set }
    var identifier: String { get }
    
    func start()
    func finish()
    func add(childCoordinator coordinator: Coordinating)
    func remove(childCoordinator coordinator: Coordinating)
    
    func onLogout()
}
