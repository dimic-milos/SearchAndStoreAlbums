//
//  HeaderView.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

class HeaderView: UIView {

    // MARK: - Properties
    
    weak var delegate: HeaderViewDelegate?
    
     // MARK: - Action methods
    
    @IBAction func buttonSearchForArtistsTapped(_ sender: UIButton) {
        os_log(.info, log: .action, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        delegate?.didTapButtonSearchForArtists(self)
    }
    

}
