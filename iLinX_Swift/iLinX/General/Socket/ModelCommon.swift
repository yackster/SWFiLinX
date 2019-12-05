//
//  ModelCommon.swift
//  iLinX
//
//  Created by Vikas Ninawe on 04/12/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import Foundation

enum ContainerType:Int {
    case playlistWithPlayer
    case startUp
    case selectedRoomDetails
}

enum Element:String {
    case report  // for rooms
    case source  // for input source
    case item  // for folder menus
    case error  // for error condition
    case song  // for actual song
    case equalizer // for equalizer
    case restore
    case volume // for volume
    case mute // for mute
    case active // for active
    case amp // for amp
    case currentSong // For current playing song
    case audioSetting // for current room audo setting fetch
    case pause // pause song
    case play // play song
    case stop //stop song
    case next // next song
    case prev // previous song
    case shuffle // shuffle songs
    case loudness // loudness for presets
    case multiRoomCreate
    case multiRoomJoin
    case multiRoomLeave
    case multiRoomCancel
    case multiRoomVolume // for multiroom volume
    case multiRoomMute // for multiroom mute
    case multiRoomAmp // for multiroom amp
    case multiRoomPowerOnOff // for multiroom power on/off
    case favourite
    
    case none
}

enum SettingControl{
    case balance
    case bass
    case trouble
    case loud
    
    case band1
    case band2
    case band3
    case band4
    case band5
    
    case volume
}

enum AVPlayerStatus:String{
    case idle
    case reload
    case pause
    case play
    case stop
    case next
    case prev
}

enum MultiRoomStatus:String{
    case idle
    case join
    case leave
    case cancel
    case create
}

struct ResponseType{
    static let report = "REPORT"
    static let menu_resp = "MENU_RESP"
}

struct DefaultValues{
    static let startcount = "1"
    static let endCount = "10" //10
    static let maxEndCount = "500" //"20" // 200  //661
}

struct Controls {
    var name:String?
    var isSelected:Bool?
    var imageName:String?
    
    init(name:String, isSelected:Bool, imageName:String){
        self.name = name
        self.isSelected = isSelected
        self.imageName = imageName
    }
}

struct Media {
    var name:String?
    var isSelected:Bool?
    var imageName:String?
    
    init(name:String, isSelected:Bool, imageName:String){
        self.name = name
        self.isSelected = isSelected
        self.imageName = imageName
    }
}

struct Presets {
    var name:String?
    var value:String?
    var isSelected:Bool?
    
    init(name:String, isSelected:Bool, value:String){
        self.name = name
        self.isSelected = isSelected
        self.value = value
    }
}

struct MediaPresets {
    var name:String?
    var isSelected:Bool?
    
    init(name:String, isSelected:Bool){
        self.name = name
        self.isSelected = isSelected
    }
}

struct SelectedItemDetails {
    static var oldRoomName:String = ""
    static var roomName:String = ""
    static var oldInputSourceName:String = ""
    static var inputSourceName:String = ""
    static var type:SelectedType = .none
    static var roomIndex:Int = -1
    static var inputSourceIndex:Int = -1
    static var selectedPath:String = ""
    static var selectedSongPath:String = ""
    static var selectedHierarchyPath:String = ""
    static var start:String = "1"
    static var end:String = "10"
    static var elementType:Element = .none
    
    enum SelectedType {
        case rooms
        case inputsources
        case controls
        case none
    }
}
