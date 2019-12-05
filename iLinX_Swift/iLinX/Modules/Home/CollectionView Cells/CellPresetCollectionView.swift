//
//  CellPresetCollectionView.swift
//  iLinX
//
//  Created by Vikas Ninawe on 14/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

class CellPresetCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var lblPresetName: UILabel!
    @IBOutlet weak var vwBackground: UIView!
    
    override func awakeFromNib() {
        //self.vwBackground.backgroundColor = .white
        //self.vwBackground.layer.cornerRadius = 5
        //self.vwBackground.clipsToBounds = true
        
        self.vwBackground.addShadowAllSide()
    }
    
    func setPresetValues(values:Presets){
        self.lblPresetName.text = values.name?.localized
        self.lblPresetName.textColor = .iLinXGrayColor
        guard SelectedItemDetails.roomIndex > -1 else{return}
        guard ModelHome.availableRooms.count > 0 else{return}
        
        if let loud = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.loud{
            if let loudValue = values.value, loudValue == loud{
                self.lblPresetName.textColor = .iLinXBlueColor
            }
        }
    }
}
