//
//  ModelHome.swift
//  iLinX
//
//  Created by Vikas Ninawe on 13/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import Foundation

class ModelHome{
    
    static var arrLog = [LogData]()
    static var availableRooms = [AvailableRooms]()
    static var currentPlayingSongs = [CurrentPlayingSongs]()
    static var rooms = [String]()
    static var inputStreams = [String]()
    static var isConnectedToNetStream = false
    static var connectWhileSuspended = false
    
    static var controls = [
                            //["heading":"audiovideo","imageName":"audiovideo"],
                            ["heading":"favourite","imageName":"favourite"],
                            ["heading":"audiosetting","imageName":"audiosetting"],
                            ["heading":"multirooms","imageName":"multirooms"]
                        ]
    
    static var mediaPresets = ["media"] //["media", "presets"]
    static var presets = [
                            ["name":"loudness", "value":"16"],
                            ["name":"custom", "value":"-1"],
                            ["name":"flat", "value":"0"],
                            ["name":"rock", "value":"1"],
                            ["name":"soft_rock", "value":"2"],
                            ["name":"jazz", "value":"3"],
                            ["name":"classical", "value":"4"],
                            ["name":"dance", "value":"5"],
                            ["name":"pop", "value":"6"],
                            ["name":"soft", "value":"7"],
                            ["name":"hard", "value":"8"],
                            ["name":"party", "value":"9"],
                            ["name":"vocal", "value":"10"],
                            ["name":"hip_hop", "value":"11"],
                            ["name":"dialog", "value":"12"]
                        ]
    
    
    //MARK: add log to logs screen
    static func addLog(str:String){
        var logDict = [String:String]()
        logDict.updateValue(str, forKey: "msg")
        logDict.updateValue("\(Date())", forKey: "date")
        ModelHome.arrLog.append(LogData(dictionary:logDict)!)
        NotificationCenter.default.post(name: .uiUpdateLog, object: nil, userInfo: [:])
    }
    
    //MARK: extract data from string recieved from socket
    static func extractData(str:String){
        
        defer { // update files in folder (once current block completely executed)
            //let _ = PostNotification.init(selectedType:.inputsources)
            let _ = PostNotification.init()
        }
        
        let arrOfStrSliptByHashWithAtTheRate = str.components(separatedBy: "#@")
        guard arrOfStrSliptByHashWithAtTheRate.count > 0 else{ return;}
        for s in arrOfStrSliptByHashWithAtTheRate{
            self.sortData(s)
        }
    }
    
    //MARK: Validate and filter/sort data based on type
    static func sortData(_ str:String){
        guard str.contains(ResponseType.report) || str.contains(ResponseType.menu_resp) else { return; }  // check for valid data
        var toAddressFinal:String?
        var fromAddressFinal:String?
        var sourceFinal:String?

        let arrOfStrSplitByHash = str.components(separatedBy: "#")
    
        if arrOfStrSplitByHash.count > 0{
            let addressData = arrOfStrSplitByHash[0]
            let arrOfStrSplitByTilde = addressData.components(separatedBy: "~")
            
            if arrOfStrSplitByTilde.count > 0{
                let toAddress = arrOfStrSplitByTilde[0] // device address or ID which send the message
                toAddressFinal = toAddress
            }
            
            if arrOfStrSplitByTilde.count > 1{
                let fromAddressWithSource = arrOfStrSplitByTilde[1] // local address + port along with source name
                let arrOfStrSplitByColon = fromAddressWithSource.components(separatedBy: ":")
                
                if arrOfStrSplitByColon.count > 0{
                    let fromAddress = arrOfStrSplitByColon[0]
                    fromAddressFinal = fromAddress
                }
                
                if arrOfStrSplitByColon.count > 1{
                    let source = arrOfStrSplitByColon[1]
                    sourceFinal = source
                }
            }
        }
        
        guard arrOfStrSplitByHash.count > 1 else { return; }
        let xmlData = arrOfStrSplitByHash[1]
        if xmlData.contains(ResponseType.report){
            if let r1 = xmlData.range(of: "{{")?.upperBound,
                let r2 = xmlData.range(of: "}}")?.lowerBound {
                let xmlStr = String(xmlData[r1..<r2])
                if (xmlStr.contains("sngPlTotal") && xmlStr.contains("sngPlIndex")) ||
                    (xmlStr.contains("sngPlTotal") && xmlStr.contains("elapsed") && xmlStr.contains("artwork")) ||
                    (xmlStr.contains("artwork") && xmlStr.contains("source") && xmlStr.contains("controlState")) ||
                    (xmlStr.contains("caption") && xmlStr.contains("band") && xmlStr.contains("frequency")) { // report as source
                    let parser = ParseXMLData<ReportSource>(xml: xmlStr)
                    let reportSource = parser.parseXML().first //  report state as first record
                    
                    var dict = [String:Any]()
                    if let sourceName = sourceFinal{
                        dict.updateValue(sourceName, forKey: "sourceName")
                    }
                    //Tausif
                    if parser.arrObj.count > 0 {
                        if let sngPlTotal = parser.arrObj[0].sngPlTotal{
                            dict.updateValue(sngPlTotal, forKey: "sngPlTotal")
                        }
                    }
                    
                    dict.updateValue(SelectedItemDetails.roomName, forKey: "roomName")
                    if let songStatus = reportSource{ dict.updateValue(songStatus, forKey: "songStatus") }
                    
                    let playingSong = CurrentPlayingSongs.init(dictionary: dict)
                    
                    // Add/Update items in playing songs(check with room and source)
                    let arrTmp = self.currentPlayingSongs.filter{$0.roomName == playingSong?.roomName && $0.sourceName == playingSong?.sourceName} // check if roomnames and sourcenames are equal
                    if arrTmp.count < 1{ // add new playing song (add all the values)
                        if let playingSongFinal = playingSong{
                            self.currentPlayingSongs.append(playingSongFinal)
                        }
                    }else{ // update room (only room setting)
                        guard let songStatus = playingSong?.songStatus, let _ = songStatus.song else{return}
                        arrTmp[0].songStatus = playingSong?.songStatus
                    }
                    
                    if let roomName = playingSong?.roomName, let sourceName = playingSong?.sourceName{
                        let _ = PostNotification.init(room: roomName, source:sourceName) // update AVPlayer for current playing song
                    }
                    
                }else{ // report as state
                    let parser = ParseXMLData<ReportState>(xml: xmlStr)
                    let reportState = parser.parseXML().first //  report state as first record
                    
                    if xmlStr.contains("currentSource") && xmlStr.contains("currentSourceIP"){
                        if let source = reportState?.currentSource, source.count > 0{
                            if SelectedItemDetails.roomName == sourceFinal && SelectedItemDetails.inputSourceName != source{
                                let _ = PostNotification.init(source:source) // update input source
                                return;
                            }
                        }
                    }
                    
                    var dict = [String:Any]()
                    if xmlStr.contains("DHCP_EN") && xmlStr.contains("staticIP_EN"){ // For network query response
                        guard ModelHome.availableRooms.count > 0 else{return;} //stop if no rooms avail
                        if let roomName = ModelHome.availableRooms[0].roomName{dict.updateValue(roomName, forKey: "roomName")}
                    }else{
                        if let roomName = sourceFinal{ dict.updateValue(roomName, forKey: "roomName") }
                    }
                    dict.updateValue(false, forKey: "isSelected")
                    dict.updateValue("", forKey: "selectedPath")
                    if let toAddress = toAddressFinal{ dict.updateValue(toAddress, forKey: "toAddress") }
                    if let fromAddress = fromAddressFinal{ dict.updateValue(fromAddress, forKey: "fromAddress") }
                    if let roomSetting = reportState{ dict.updateValue(roomSetting, forKey: "roomSetting") }
                    dict.updateValue([], forKey: "inputSources") // initialize with empty input sources
                    
                    let availRoom = AvailableRooms.init(dictionary: dict)
                    
                    // Add/Update items in rooms
                    let arrTmp = self.availableRooms.filter{$0.roomName == availRoom?.roomName} // check if roomnames are equal
                    if arrTmp.count < 1{ // add new room (add all the values)
                        let roomTypeList = ["state"]
                        if let availRoomFinal = availRoom, let type = availRoom?.roomSetting?.type, roomTypeList.contains(type){
                            self.availableRooms.append(availRoomFinal)
                        }
                    }else{ // update room (only room setting)
                        if self.isConnectedToNetStream {
                            guard let roomSetting = availRoom?.roomSetting, let _ = roomSetting.ampOn, let _ = roomSetting.vol  else{return}
                            arrTmp[0].roomSetting = roomSetting
                        }else{
                            arrTmp[0].roomSetting = availRoom?.roomSetting
                        }

                        let notif = NotificationCenter.default
                        notif.post(name: .uiUpdateSetting, object: nil, userInfo: nil)
                    }
                    // Update room list tableview //@@@
                    //let _ = PostNotification.init(selectedType:.rooms) //already updating from callCommandGetRooms function
                }
            }
        }else if xmlData.contains(ResponseType.menu_resp){
            if let r1 = xmlData.range(of: "{{")?.upperBound,
                let r2 = xmlData.range(of: "}}")?.lowerBound {
                let xmlStr = String(xmlData[r1..<r2])
                let parser = ParseXMLData<MenuResp>(xml: xmlStr)
                let menuListResp = parser.parseXML().first //  MenuListResp as first record
                
                var dict = [String:Any]()
                if let sourceName = menuListResp?.display{ dict.updateValue(sourceName, forKey: "sourceName") }
                if let roomName = sourceFinal{ dict.updateValue(roomName, forKey: "roomName") }
                dict.updateValue(false, forKey: "isSelected")
                if let toAddress = toAddressFinal{ dict.updateValue(toAddress, forKey: "toAddress") }
                if let fromAddress = fromAddressFinal{ dict.updateValue(fromAddress, forKey: "fromAddress") }
                if let sourceSetting = menuListResp{ dict.updateValue(sourceSetting, forKey: "sourceSetting") }
                dict.updateValue([], forKey: "menuList") // initialize with empty input sources
                
                let availInputSource = AvailableInputSourcesForRoom.init(dictionary: dict)
                let availFavourite = AvailableFavouritesForRoom.init(dictionary: [String:Any]()) // @@@
                let arrRoomTmp = self.availableRooms.filter{$0.roomName == availInputSource?.roomName}
                if arrRoomTmp.count > 0{ // if response contain room name
                    
                    // Add/Update items in input sources list
                    var arrSource = arrRoomTmp[0].inputSources.filter{$0.sourceName == availInputSource?.sourceName}
                    if arrSource.count < 1{ // add input sources (add all the values)
                        let sourceTypeList = ["audio/source","source"]
                        if let availInputSourceFinal = availInputSource, let type = availInputSource?.sourceSetting?.type, sourceTypeList.contains(type){
                            arrRoomTmp[0].inputSources.append(availInputSourceFinal)
                        }
                    }else{ // update new input sources (only source setting)
                        arrSource[0].sourceSetting = availInputSource?.sourceSetting
                    }
                
                    let _ = PostNotification.init(selectedType:.inputsources) // update input source list
                    
                }else{ // if response string contain input source name (room name not present in menuresp)
                    let arrRoomTmp = self.availableRooms.filter{$0.roomName == SelectedItemDetails.roomName}
                    
                    // Add/Update items in input sources list
                    var arrSource = arrRoomTmp[0].inputSources.filter{$0.sourceName == availInputSource?.roomName} // roomName is sourceName (response do not contain roomname, so, sourcename stored as roomname in object)
                    
                    guard arrSource.count > 0 else { return;} // update new input sources (only source setting)
                        
                    // Add/Update items in menulist
                    var arrMenu = arrSource[0].menuList.filter{$0.display == availInputSource?.sourceSetting?.display && $0.idPath == availInputSource?.sourceSetting?.idPath}
                    if arrMenu.count < 1{ // add new (do not add error data or data with display = "")
                        if let sourceSettingFinal = availInputSource?.sourceSetting, sourceSettingFinal.display != "" {
                            if sourceSettingFinal.elementName?.lowercased() == Element.error.rawValue{ //  do not add error values
                                let _ = PostNotification.init(error: sourceSettingFinal.display ?? "errorFound".localized)
                            }else if let _ = sourceSettingFinal.id{ // add only if id present
                                arrSource[0].menuList.append(sourceSettingFinal)
                            }
                        }
                    }else{ // update existing
                        if let sourceSettingFinal = availInputSource?.sourceSetting{
                            arrMenu[0] = sourceSettingFinal
                        }
                    }
                }
            }
        }
    }
    
}


