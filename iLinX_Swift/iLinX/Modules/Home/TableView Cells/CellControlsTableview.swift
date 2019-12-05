//
//  CellControlsTableview.swift
//  iLinX
//
//  Created by Vikas Ninawe on 29/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

class CellControlsTableview: UITableViewCell {

    @IBOutlet weak var imgVwControlImg: UIImageView!
    @IBOutlet weak var lblControlName: UILabel!
    @IBOutlet weak var btnControl: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setValues(values:Controls){
        self.lblControlName.textColor = values.isSelected! ? .iLinXBlueColor : .iLinXGrayColor
        self.imgVwControlImg.image = UIImage(named: values.imageName!)
        self.lblControlName.text = values.name
       // print("lblName \(self.lblControlName.text)")
    }

}
