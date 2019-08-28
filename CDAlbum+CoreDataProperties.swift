//
//  CDAlbum+CoreDataProperties.swift
//  
//
//  Created by Dimic Milos on 8/28/19.
//
//

import Foundation
import CoreData


extension CDAlbum {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAlbum> {
        return NSFetchRequest<CDAlbum>(entityName: "CDAlbum")
    }

    @NSManaged public var name: String?
    @NSManaged public var artist: String?
    @NSManaged public var tracks: [String]?

}
