//
//  RoundedButton.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        setTitleColor(.white, for: .normal)
        setTitleColor(.gray, for: .highlighted)
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = rect.height/2
        
    }    
}
