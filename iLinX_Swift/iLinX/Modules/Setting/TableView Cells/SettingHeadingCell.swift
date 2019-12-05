//
//  SettingHeadingCell.swift
//  iLinX
//
//  Created by Vikas Ninawe on 07/02/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//

import UIKit

class SettingHeadingCell: UITableViewCell {

    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnHeading: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setValues(values:[String:Any]){
        
    }

}
