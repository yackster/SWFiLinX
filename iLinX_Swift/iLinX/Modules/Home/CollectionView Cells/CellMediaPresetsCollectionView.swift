//
//  CellMediaPresetsCollectionView.swift
//  iLinX
//
//  Created by Vikas Ninawe on 14/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

class CellMediaPresetsCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var lblCollectionName: UILabel!
    
    func setValues(values:MediaPresets){
        self.lblCollectionName.textColor = values.isSelected! ? .black : .iLinXGrayColor
        self.lblCollectionName.text = values.name
    }
    
}
