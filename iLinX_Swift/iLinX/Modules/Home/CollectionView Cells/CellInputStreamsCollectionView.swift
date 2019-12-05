//
//  CellInputStreamsCollectionView.swift
//  iLinX
//
//  Created by Vikas Ninawe on 30/10/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

class CellInputStreamsCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var lblInputStreamName: UILabel!
    @IBOutlet weak var vwLine: UIView!
    
    func setValues(values:AvailableInputSourcesForRoom){
        
        self.lblInputStreamName.textColor = values.isSelected! ? .iLinXBlueColor : .iLinXGrayColor
        self.vwLine.backgroundColor = values.isSelected! ? .iLinXBlueColor : .white
        //self.lblInputStreamName.text = values.sourceName
        self.lblInputStreamName.text = values.displaySourceName
    }
    
}
