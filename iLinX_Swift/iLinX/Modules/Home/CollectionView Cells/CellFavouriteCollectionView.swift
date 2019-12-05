//
//  CellFavouriteCollectionView.swift
//  iLinX
//
//  Created by Vikas Ninawe on 05/04/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//

import UIKit

class CellFavouriteCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var vwBase: UIView!
    
    override func awakeFromNib() {
        self.vwBase.addShadowAllSide()
    }
    
    func setValues(values:AvailableFavouritesForRoom){
        if let favourite = values.display{
            self.btnFavourite.setTitle(favourite.capitalized, for: .normal)
        }
    }
    
}
