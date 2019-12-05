//
//  CellRoomsTableView.swift
//  iLinX
//
//  Created by Vikas Ninawe on 30/10/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

class CellRoomsTableView: UITableViewCell {
    
    @IBOutlet weak var lblRoomName: UILabel!
    @IBOutlet weak var lblMultiroom: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblMultiroom.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setValues(values:AvailableRooms){
        if let audioSessionActive = values.roomSetting?.audioSessionActive{
            if audioSessionActive == "1"{
                if let audioSession = values.roomSetting?.audioSession, audioSession.count > 0{
                    self.lblMultiroom.text = audioSession.lowercased().replacingOccurrences(of: "multiroom", with: "").capitalized
                }else{
                    self.lblMultiroom.text = "multiroom".localized
                }
            }else if audioSessionActive == "" || audioSessionActive == "0"{
                self.lblMultiroom.text =  "" // For multiroom status
            }
        }
        self.lblRoomName.textColor = (values.isSelected!) ? .iLinXBlueColor : .iLinXGrayColor
        self.lblRoomName.text = (values.displayRoomName)
    }

}
