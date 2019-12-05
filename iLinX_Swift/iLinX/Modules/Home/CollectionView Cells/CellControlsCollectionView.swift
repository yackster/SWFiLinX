//
//  CellControlsCollectionView.swift
//  iLinX
//
//  Created by Vikas Ninawe on 13/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

class CellControlsCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var imgVwControl: UIImageView!
    @IBOutlet weak var lblControlName: UILabel!
    @IBOutlet weak var vwBackground: UIView!
    
    func setValues(values:Controls){
        self.vwBackground.setDropShadowWithRoundedCorner()
        
        self.lblControlName.textColor = values.isSelected! ? .white : .iLinXGrayColor
        self.vwBackground.backgroundColor = values.isSelected! ? .iLinXBlueColor : .white
        self.imgVwControl.image = UIImage(named: values.imageName! + (values.isSelected! ? "_selected" : "_unselected"))
        self.lblControlName.text = values.name
    }
}
