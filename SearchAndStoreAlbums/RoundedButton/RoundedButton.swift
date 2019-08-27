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
    
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        if let titleText = titleLabel?.text, let font = titleLabel?.font {
            let width = titleText.size(withAttributes: [NSAttributedString.Key.font: font]).width
            return CGSize(width: width + 20 , height: originalSize.height)
        } else {
            return super.intrinsicContentSize
        }
    }
}
