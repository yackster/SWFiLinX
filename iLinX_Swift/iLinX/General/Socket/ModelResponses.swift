//
//  ModelResponses.swift
//  iLinX
//
//  Created by Vikas Ninawe on 03/12/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import Foundation

protocol Appendable{
    init?(element:String, dictionary: [String : Any])
}

class LogData{
    var msg:String?
    var date:String?
    
    required init?(dictionary: [String : String]) {
        self.msg = dictionary["msg"]
        self.date = dictionary["date"]
    }
}


class ReportSource:Appendable{
    var elementName:String?
    var type:String?
    var song:String?
    var sngPlTotal:String?
    var next:String?
    var elapsed:String?
    var controlState:String?
    var genre:String?
    var sngPlIndex:String?
    var album:String?
    var display:String?
    var time:String?
    var artwork:String?
    var caption:String?
    var shuffle:String?
    var pwrOn:String?
    var artist:String?
    var band:String?
    var frequency:String?
    var extended:String?
    var source:String?
    
    required init?(element:String, dictionary: [String : Any]) {
        self.elementName = element
        self.type = dictionary["type"] as? String
        self.song = dictionary["song"] as? String
        self.sngPlTotal = dictionary["sngPlTotal"] as? String
        self.next = dictionary["next"] as? String
        self.elapsed = dictionary["elapsed"] as? String
        self.controlState = dictionary["controlState"] as? String
        self.genre = dictionary["genre"] as? String
        self.sngPlIndex = dictionary["sngPlIndex"] as? String
        self.album = dictionary["album"] as? String
        self.display = dictionary["display"] as? String
        self.time = dictionary["time"] as? String
        self.artwork = dictionary["artwork"] as? String
        self.caption = dictionary["caption"] as? String
        self.shuffle = dictionary["shuffle"] as? String
        self.pwrOn = dictionary["pwrOn"] as? String
        self.artist = dictionary["artist"] as? String
        self.band = dictionary["band"] as? String
        self.frequency = dictionary["frequency"] as? String
        self.extended = dictionary["extended"] as? String
        self.source = dictionary["source"] as? String
    }
}

class ReportState:Appendable{
    var elementName:String?
    var type:String?
    var vol:String?
    var balance:String?
    var bass:String?
    var treb:String?
    var loud:String?
    var mute:String?
    var audioSession:String?
    var audioSessionActive:String?
    var band_1:String?
    var band_2:String?
    var band_3:String?
    var band_4:String?
    var band_5:String?
    var ampOn:String?
    var active:String?
    var sleep:String?
    var currentSource:String?
    var currentSourceIP:String?
    var permId:String?
    var sourceType:String?
    var controlType:String?
    var serviceName:String?
    var serviceType:String?
    var IP:String?
    var enabled:String?
    var IRPort:String?
    var roomName:String?
    var groupName:String? //"ALL"
    var groupName1:String? //"Audio_Renderers"
    var DHCP_EN:String?
    var staticIP_EN:String?
    var IPMask:String?
    var gatewayIP:String?
    
    required init?(element:String, dictionary: [String : Any]) {
        self.elementName = element
        self.type = dictionary["type"] as? String
        self.vol = dictionary["vol"] as? String
        self.balance = dictionary["balance"] as? String
        self.bass = dictionary["bass"] as? String
        self.treb = dictionary["treb"] as? String
        self.loud = dictionary["loud"] as? String
        self.mute = dictionary["mute"] as? String
        self.audioSession = dictionary["audioSession"] as? String
        self.audioSessionActive = dictionary["audioSessionActive"] as? String
        self.band_1 = dictionary["band_1"] as? String
        self.band_2 = dictionary["band_2"] as? String
        self.band_3 = dictionary["band_3"] as? String
        self.band_4 = dictionary["band_4"] as? String
        self.band_5 = dictionary["band_5"] as? String
        self.ampOn = dictionary["ampOn"] as? String
        self.active = dictionary["active"] as? String
        self.sleep = dictionary["sleep"] as? String
        self.currentSource = dictionary["currentSource"] as? String
        self.currentSourceIP = dictionary["currentSourceIP"] as? String
        self.permId = dictionary["permId"] as? String
        self.sourceType = dictionary["sourceType"] as? String
        self.controlType = dictionary["controlType"] as? String
        self.serviceName = dictionary["serviceName"] as? String
        self.serviceType = dictionary["serviceType"] as? String
        self.IP = dictionary["IP"] as? String
        self.enabled = dictionary["enabled"] as? String
        self.IRPort = dictionary["IRPort"] as? String
        self.roomName = dictionary["roomName"] as? String
        self.groupName = dictionary["groupName"] as? String
        self.groupName1 = dictionary["groupName"] as? String
        self.DHCP_EN = dictionary["DHCP_EN"] as? String
        self.staticIP_EN = dictionary["staticIP_EN"] as? String
        self.IPMask = dictionary["IPMask"] as? String
        self.gatewayIP = dictionary["gatewayIP"] as? String
    }
}

class MenuResp:Appendable {
    var elementName:String?
    var idPath:String?
    var itemNum:String?
    var itemselectable:String?
    var id:String?
    var dispPath:String?
    var display:String?
    var children:String?
    var ip:String?
    var type:String?
    var otherData:String?
    var moreData:String?
    
    required init?(element:String, dictionary: [String : Any]) {
        self.elementName = element
        self.idPath = dictionary["idpath"] as? String
        self.itemNum = dictionary["itemnum"] as? String
        self.itemselectable = dictionary["itemselectable"] as? String
        self.id = dictionary["id"] as? String
        self.dispPath = dictionary["disppath"] as? String
        self.display = dictionary["display"] as? String
        self.children = dictionary["children"] as? String
        self.ip = dictionary["ip"] as? String
        self.type = dictionary["type"] as? String
        self.otherData = dictionary["otherData"] as? String
        self.moreData = dictionary["moreData"] as? String
    }
}
extension MenuResp: Equatable {
    static func == (lhs: MenuResp, rhs: MenuResp) -> Bool {
        return lhs.display == rhs.display && lhs.id == rhs.id
    }
}

class AvailableFavouritesForRoom{
    var id:String?
    var macro:String?
    var display:String?
    var isSelected:Bool?
    var roomName:String?
    
    required init?(dictionary:[String:Any]){
        self.id = dictionary["id"] as? String
        self.macro = dictionary["macro"] as? String
        self.display = dictionary["display"] as? String
        self.isSelected = dictionary["isSelected"] as? Bool
        self.roomName = dictionary["roomName"] as? String
    }
}

class AvailableInputSourcesForRoom{
    var displaySourceName:String?
    var sourceName:String?
    var roomName:String?
    var isSelected:Bool?
    var toAddress:String?
    var fromAddress:String?
    var sourceSetting:MenuResp?
    var menuList:[MenuResp] = []
    
    required init?(dictionary:[String:Any]){
        self.displaySourceName = dictionary["displaySourceName"] as? String
        self.sourceName = dictionary["sourceName"] as? String
        self.roomName = dictionary["roomName"] as? String
        self.isSelected = dictionary["isSelected"] as? Bool
        self.toAddress = dictionary["toAddress"] as? String
        self.fromAddress = dictionary["fromAddress"] as? String
        self.sourceSetting = dictionary["sourceSetting"] as? MenuResp
        if let menu = dictionary["menuList"] as? [MenuResp]{
            self.menuList = menu
        }
    }
}

class AvailableRooms{
    var displayRoomName:String?
    var enabled:String?
    var roomName:String?
    var selectedPath:String?
    var isSelected:Bool?
    var toAddress:String?
    var fromAddress:String?
    var roomSetting:ReportState? // XML data
    var inputSources:[AvailableInputSourcesForRoom] = []
    var favourites:[AvailableFavouritesForRoom] = []
    
    required init?(dictionary:[String:Any]){
        self.displayRoomName = dictionary["displayRoomName"] as? String
        self.enabled = dictionary["enabled"] as? String
        self.roomName = dictionary["roomName"] as? String
        self.selectedPath = dictionary["selectedPath"] as? String
        self.isSelected = dictionary["isSelected"] as? Bool
        self.toAddress = dictionary["toAddress"] as? String
        self.fromAddress = dictionary["fromaddress"] as? String
        self.roomSetting = dictionary["roomSetting"] as? ReportState
        if let sources = dictionary["inputSources"] as? [AvailableInputSourcesForRoom]{
            self.inputSources = sources
        }
        if let favourites = dictionary["favourites"] as? [AvailableFavouritesForRoom]{
            self.favourites = favourites
        }
    }
}

class CurrentPlayingSongs{
    var roomName:String?
    var sourceName:String?
    var sngPlTotal:String?
    var songStatus:ReportSource?
    
    required init?(dictionary:[String:Any]){
        self.roomName = dictionary["roomName"] as? String
        self.sourceName = dictionary["sourceName"] as? String
        self.sngPlTotal = dictionary["sngPlTotal"] as? String
        self.songStatus = dictionary["songStatus"] as? ReportSource
    }
}









