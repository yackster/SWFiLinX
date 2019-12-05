//
//  LogCell.swift
//  iLinX
//
//  Created by Vikas Ninawe on 18/01/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {
    
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(values:LogData){
        if let msg = values.msg{
            self.lblMsg.text = msg
        }
        if let date = values.date{
            self.lblDate.text = date
        }
    }

}
