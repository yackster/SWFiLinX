//
//  QueryList.swift
//  iLinX
//
//  Created by Vikas Ninawe on 03/12/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import Foundation

class Query{
    
    static let arrSettingControls = ["BALANCE","BASS","TREB",
                                     "BAND_1","BAND_2","BAND_3","BAND_4","BAND_5",
                                     "VOL"]
    
    static let arrMultiRooms = ["All Rooms MultiRoom"]
    
    //send the control message to the system on port number 15000
    
    // get the network devices
    class func getNetworkQuery(roomName:String) -> String{
        return "#@\(roomName)~root#QUERY NETWORK"
    }
    
    // get the input source selection query
    class func getSourceSelectedQuery(roomName:String, sourceName:String) -> String{
         return "#@\(roomName)#SRC_SEL {{\(sourceName)}}"
    }
    
    // get the information about all devices (friends) in network
    class func getAllFriendSolicitQuery(ip:String, port:UInt16) -> String{
        return "#@ALL:AFRIEND#SOLICIT \(ip),\(port),ALL"  //239.255.16.90,8000
    }
    
    // get the info about all the devices (friends) in network with id
    class func getAllFriendDeviceIDQuery(ip:String, port:UInt16) -> String{
        return "#@ALL:AFRIEND#DEVICE_ID REQUEST,\(ip),\(port)" // broadcast address + 15000 port
    }
    
    // get all the rooms avails
    class func getRoomsQuery() -> String{
        return "#@ALL#QUERY RENDERER"
    }
    
    // Get details of current audio source setting(control setting)
    class func getRoomCurrentSetting(roomName:String) -> String{
        return "#@\(roomName)#QUERY RENDERER"
    }
    
    // get details of the current source selected for room
    class func getRoomCurrentSourceQuery(roomName:String) -> String{
        return "#@\(roomName)#QUERY CURRENT_SOURCE"
    }
    
    class func getRoomServiceQuery(roomName:String) -> String{
        return "#@\(roomName)~root#QUERY SERVICE {{\(roomName)}}"
    }
    
    class func getRoomRegisterQuery(roomName:String, status:Bool) -> String{
        return "#REGISTER \(status ? "OFF" : "ON"),{{\(roomName)}}"   //ON or OFF
    }
    
    class func getSourceRegisterQuery(sourceName:String, status:Bool) -> String{
        return "#REGISTER \(status ? "OFF" : "ON"),{{\(sourceName)}}"  //ON or OFF
    }
    
    class func getRoomRendererQuery(roomName:String) -> String{
        return "#@\(roomName)#QUERY RENDERER {{\(roomName)}}"
    }
    
    // get sources for selected room
    class func getRoomMenuListQuery(roomName:String, start:String = "1", end:String = "10") -> String{
        return "#@\(roomName)#MENU_LIST \(start),\(end),SOURCES"
    }
    
    // get folder list for selected input source
    class func getSourceMenuListQuery(sourceName:String, start:String = "1", end:String = "10") -> String{
        return "#@\(sourceName)#MENU_LIST \(start),\(end),media"
    }
    
    //get subfolder/songs in selected path
    class func getSourceMenuListForPathQuery(sourceName:String, path:String, start:String, end:String) -> String{
       // print("Song Name shri  \(sourceName)#MENU_LIST \(start),\(end),{{media>\(path)}")
        return "#@\(sourceName)#MENU_LIST \(start),\(end),{{media>\(path)}}"
    }
    
    //select the menu for path
    class func getPathSelectedQuery(sourceName:String, path:String) -> String{
        return "#@\(sourceName)#MENU_SEL {{media>\(path)}}" //media>
    }
    
    // get details of the current song being played
    class func getSourcePlayingSongQuery(sourceName:String) -> String{
        return "#@\(sourceName)#QUERY SOURCE"
    }
    
    //If there is no traffic on the TCP/UDP connection after 60 seconds it will be closed
    class func keepConnectionLiveWithHeartBeat() -> String{
        return "#HEARTBEAT"
    }
    
    //keep the connection alive, after every 30 seconds
    class func keepConnectionLiveWithRegister(roomName:String) -> String{
        return "#REGISTER {{\(roomName)}}"
    }
    
    // get Volume Mute on/off
    class func getVolumeMuteOnOffQuery(roomName:String, status:Bool) -> String{
        return "#@\(roomName)#MUTE \(status ? "OFF" : "ON")"
    }
    
    // get Volume Mute Toggle
//    class func getVolumeMuteToggleQuery(roomName:String, status:Bool) -> String{
//        return "#@\(roomName)#MUTE TOGGLE"  // TOGGLE to toggle the status
//    }
    
    // get room Active on/off
    class func getRoomActiveOnOffQuery(roomName:String, status:Bool) -> String{
        return "#@\(roomName)#ACTIVE \(status ? "OFF" : "ON")"
    }
    
    // get inputsource Active on/off
    class func getInputSourceActiveOnOffQuery(inputSourceName:String, status:Bool) -> String{
        return "#@\(inputSourceName)#ACTIVE \(status ? "OFF" : "ON")"
    }
    
    // get Amplifier/AV on/off
    class func getAmpOnOffQuery(roomName:String, status:Bool) -> String{
        return "#@\(roomName)#AMP \(status ? "OFF" : "ON")"
    }
    
    // Setting controls
//    class func getSettingControlUpQuery(roomName:String, settingControl:String) -> String{
//        return "#@\(roomName)#LEVEL_UP \(settingControl)"
//    }
//    class func getSettingControlDownQuery(roomName:String, settingControl:String) -> String{
//        return "#@\(roomName)#LEVEL_DN \(settingControl)"
//    }
    
    // get setting controls set
    class func getSettingControlSetQuery(roomName:String, settingControl:String, value:String) -> String{
        return "#@\(roomName)#LEVEL_SET \(settingControl), \(value)"
    }
    
    // get play paused song
    class func getPlaySongSelectedQuery(sourceName:String) -> String{
        return "#@\(sourceName)#PLAY"
    }
    
    // get pause playing song
    class func getPauseSongSelectedQuery(sourceName:String) -> String{
        return "#@\(sourceName)#PAUSE"
    }
    
    //get stop song
    class func getStopSongSelectedQuery(sourceName:String) -> String{
        return "#@\(sourceName)#STOP"
    }
    
    // get next song
    class func getNextSongSelectedQuery(sourceName:String) -> String{
        return "#@\(sourceName)#NEXT"
    }
    
    // get previous song
    class func getPreviousSongSelectedQuery(sourceName:String) -> String{
        return "#@\(sourceName)#PREV"
    }
    
    //get shuffle on/off
    class func getShuffleSongSelectedQuery(sourceName:String, status:Bool) -> String{
        return "#@\(sourceName)#SHUFFLE \(status ? "OFF" : "ON")"
    }
    
    // get preset (to set presets controls)
    class func getLoudnessQuery(roomName:String, value:String) -> String{
        return "#@\(roomName)#LOUDNESS \(value)"
    }
    
    // get multiaudio join
    class func getMultiRoomJoinQuery(roomName:String, sessionName:String) -> String{
        return "#@\(roomName)#MULTIAUDIO JOIN {{\(sessionName)}}"
    }
    
    // get multiaudio activate/create
    class func getMultiRoomCreateQuery(sessionName:String) -> String{
        return "#@Audio_Renderers#MULTIAUDIO JOIN {{\(sessionName)}}"
    }
    
    // get multiaudio active ON/OFF
    class func getMultiRoomActiveOnOffQuery(sessionName:String, status:Bool) -> String{
        return "#@\(sessionName)#ACTIVE \(status ? "OFF" : "ON")"
    }
    
    // get multiaudio Mute ON/OFF
    class func getMultiRoomMuteOnOffQuery(sessionName:String, status:Bool) -> String{
        return "#@\(sessionName)#MUTE \(status ? "OFF" : "ON")"
    }
    
    // get multiaudio AMP on/off
    class func getMultiRoomAMPOnOffQuery(sessionName:String, status:Bool) -> String{
        return "#@\(sessionName)#AMP \(status ? "OFF" : "ON")"
    }
    
    // get multiaudio Set default volume
    class func getMultiRoomSetDefaultVolumeQuery(sessionName:String) -> String{
        return "#@\(sessionName)#LEVEL_SET VOL DEFAULT"
    }
    
    // get multiaudio Set volume
    class func getMultiRoomSetVolumeQuery(sessionName:String, value:String) -> String{
        return "#@\(sessionName)#LEVEL_SET VOL \(value)"
    }
    
    // get multiaudio Set default volume
    class func getMultiRoomSelectSourceQuery(sessionName:String, source:String) -> String{
        return "#@\(sessionName)#SRC_SEL {{\(source)}}"
    }
    
    // get multiaudio deactiavte/cancel
    class func getMultiRoomCancelQuery(sessionName:String) -> String{
        return "#@\(sessionName)#MULTIAUDIO LEAVE"
    }

    // get multiaudio leave
    class func getMultiRoomLeaveQuery(roomName:String) -> String{
        return "#@\(roomName)#MULTIAUDIO LEAVE"
    }
    
    // get favourite
    class func getFavouriteQuery(roomName:String, favourite:String) -> String{
        //return "#\(favourite)"
        return "#@\(roomName)#\(favourite)"
    }
    
    
    
}

