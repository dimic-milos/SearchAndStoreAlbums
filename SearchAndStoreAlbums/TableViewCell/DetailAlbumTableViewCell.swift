//
//  DetailAlbumTableViewCell.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/28/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

class DetailAlbumTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var imageViewAlbumArt: UIImageView!
    @IBOutlet weak var labelAlbumName: UILabel!
    @IBOutlet weak var labelAvailableOffline: UILabel!
    
    
    // MARK: - Public methods
    
    func setCell(albumName: String, isAvailableOffline: Bool) {
        labelAlbumName.text = albumName
        labelAvailableOffline.textColor = isAvailableOffline ? .green : .red
    }
}
