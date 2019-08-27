//
//  UICollectionViewCell+Extensions.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    open class func reuseIdentifier() -> String {
        let descriptionParts = description().split(separator: ".")
        let finalResult = "SearchAndStoreAlbums." + String(descriptionParts.last ?? "")
        return finalResult
    }
}
