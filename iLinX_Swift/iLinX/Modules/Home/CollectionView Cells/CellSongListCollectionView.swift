//
//  CellSongListCollectionView.swift
//  iLinX
//
//  Created by Vikas Ninawe on 14/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

class CellSongListCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var cellSongListTableView: UITableView!
    @IBOutlet weak var imgVwAlbum: UIImageView!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var vwBackground: UIView!
    
    func setMediaValues(values:MenuResp){
     //   self.lblSongName.textColor = .black
      //  self.lblSongName.text = values.display
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
            case .song: self.imgVwAlbum.image = #imageLiteral(resourceName: "album")
            }
        }else{
          //  self.imgVwAlbum.image = #imageLiteral(resourceName: "warning")
        }
      //  self.imgVwAlbum.layer.cornerRadius = 3
       // self.imgVwAlbum.clipsToBounds = true
    }
}
