//
//  CellSongListTableViewCell.swift
//  iLinX
//
//  Created by Vikas Ninawe on 05/07/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//

import UIKit

class CellSongListTableViewCell: UITableViewCell {
    @IBOutlet weak var songImgView: UIImageView!
    @IBOutlet weak var songNameLbl: UILabel!
    
    @IBOutlet weak var imgVwAlbum: UIImageView!
    @IBOutlet weak var lblSongName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setMediaValues(values:MenuResp){
        if let elementName = values.elementName, let element = Element(rawValue: elementName){
            switch element{
            case .report, .source, .equalizer, .volume, .restore, .none: break;
            case .active, .mute, .amp, .currentSong, .audioSetting, .loudness: break;
            case .prev, .next, .stop, .play, .pause, .shuffle: break;
            case .multiRoomCreate, .multiRoomJoin, .multiRoomLeave, .multiRoomCancel : break;
            case .multiRoomVolume, .multiRoomMute, .multiRoomAmp, .multiRoomPowerOnOff: break;
            case .favourite :break;
            case .error: self.imgVwAlbum.image = #imageLiteral(resourceName: "warning")
            case .item: self.imgVwAlbum.image = #imageLiteral(resourceName: "folder")
            case .song: self.imgVwAlbum.image = #imageLiteral(resourceName: "iLinxSong")
            }
        }else{
            //  self.imgVwAlbum.image = #imageLiteral(resourceName: "warning")
        }
        self.lblSongName.textColor = .black
        self.lblSongName.text = values.display
        self.imgVwAlbum.layer.cornerRadius = 3
        self.imgVwAlbum.clipsToBounds = true
    }
}
