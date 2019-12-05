//
//  ModelXMLFileData.swift
//  iLinX
//
//  Created by Vikas Ninawe on 06/02/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//

import Foundation

class XMLFileData : Codable {
    let gui : Gui?
    
    enum CodingKeys: String, CodingKey {
        case gui = "gui"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gui = try values.decodeIfPresent(Gui.self, forKey: .gui)
    }
}

class Gui : Codable {
    let allOffEnabled : String?
    let schema : String?
    let searchEntryMethod : String?
    let timeStamp : String?
    let rooms : Rooms?
    let cameras : Cameras?
    let sources : Sources?
    let avrs : Avrs?
    
    enum CodingKeys: String, CodingKey {
        case allOffEnabled = "_allOffEnabled"
        case schema = "_schema"
        case searchEntryMethod = "_searchEntryMethod"
        case timeStamp = "_timeStamp"
        case rooms = "rooms"
        case cameras = "cameras"
        case sources = "sources"
        case avrs = "avrs"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        allOffEnabled = try values.decodeIfPresent(String.self, forKey: .allOffEnabled)
        schema = try values.decodeIfPresent(String.self, forKey: .schema)
        searchEntryMethod = try values.decodeIfPresent(String.self, forKey: .searchEntryMethod)
        timeStamp = try values.decodeIfPresent(String.self, forKey: .timeStamp)
        rooms = try values.decodeIfPresent(Rooms.self, forKey: .rooms)
        cameras = try values.decodeIfPresent(Cameras.self, forKey: .cameras)
        sources = try values.decodeIfPresent(Sources.self, forKey: .sources)
        avrs = try values.decodeIfPresent(Avrs.self, forKey: .avrs)
    }
}

class Avrs : Codable {
    let type : String?
    enum CodingKeys: String, CodingKey {
        case type = "_type"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
}

class Sources : Codable {
    let source : [Source]?
    
    enum CodingKeys: String, CodingKey {
        case source = "source"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        source = try values.decodeIfPresent([Source].self, forKey: .source)
    }
}

class Source : Codable {
    let sourceType : String?
    let icon : String?
    let controlType : String?
    let serviceName : String?
    let browseScreen :String?
    let type : String?
    let searchable : String?
    let itemnum : String?
    let greenText : String?
    let yellowText : String?
    let redText : String?
    let blueText : String?
    
    enum CodingKeys: String, CodingKey {
        case sourceType = "_sourceType"
        case icon = "_icon"
        case controlType = "_controlType"
        case serviceName = "_serviceName"
        case browseScreen = "_browseScreen"
        case type = "_type"
        case searchable = "_searchable"
        case itemnum = "_itemnum"
        case greenText = "_greenText"
        case yellowText = "_yellowText"
        case redText = "_redText"
        case blueText = "_blueText"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sourceType = try values.decodeIfPresent(String.self, forKey: .sourceType)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        controlType = try values.decodeIfPresent(String.self, forKey: .controlType)
        serviceName = try values.decodeIfPresent(String.self, forKey: .serviceName)
        browseScreen = try values.decodeIfPresent(String.self, forKey: .browseScreen)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        searchable = try values.decodeIfPresent(String.self, forKey: .searchable)
        itemnum = try values.decodeIfPresent(String.self, forKey: .itemnum)
        greenText = try values.decodeIfPresent(String.self, forKey: .greenText)
        yellowText = try values.decodeIfPresent(String.self, forKey: .yellowText)
        redText = try values.decodeIfPresent(String.self, forKey: .redText)
        blueText = try values.decodeIfPresent(String.self, forKey: .blueText)
    }
}

class Rooms : Codable {
    let room : [Room]?
    
    enum CodingKeys: String, CodingKey {
        case room = "room"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        room = try values.decodeIfPresent([Room].self, forKey: .room)
    }
}

class Room : Codable {
    let id : String?
    let privacy : String?
    let screens : Screens?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case privacy = "_privacy"
        case screens = "screens"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        privacy = try values.decodeIfPresent(String.self, forKey: .privacy)
        screens = try values.decodeIfPresent(Screens.self, forKey: .screens)
    }
}

class Screens : Codable {
    let screen : [Screen]?
    
    enum CodingKeys: String, CodingKey {
        case screen = "screen"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        screen = try values.decodeIfPresent([Screen].self, forKey: .screen)
    }
}

class Screen : Codable {
    let serviceName : String?
    let settingsEnabled : String?
    let enabled : String?
    let id : String?
    let type : String?
    let menu : [Menu]?
    let favourite : [Favourite]?
    //let cameras : Cameras?
    let defaultMic : String?
    
    enum CodingKeys: String, CodingKey {
        case serviceName = "_serviceName"
        case settingsEnabled = "_settingsEnabled"
        case enabled = "_enabled"
        case id = "_id"
        case type = "_type"
        case menu = "menu"
        case favourite = "favorite"
        //case cameras = "cameras"
        case defaultMic = "_defaultMic"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        serviceName = try values.decodeIfPresent(String.self, forKey: .serviceName)
        settingsEnabled = try values.decodeIfPresent(String.self, forKey: .settingsEnabled)
        enabled = try values.decodeIfPresent(String.self, forKey: .enabled)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        menu = try values.decodeIfPresent([Menu].self, forKey: .menu)
        favourite = try values.decodeIfPresent([Favourite].self, forKey: .favourite)
        //cameras = try values.decodeIfPresent(Cameras.self, forKey: .cameras)
        defaultMic = try values.decodeIfPresent(String.self, forKey: .defaultMic)
    }
}

class Camera : Codable {
    //let controls : Controls?
    //let presets : Presets?
    let id : String?
    //let alias : String?
    //let ip : String?
    //let image : String?
    //let port : String?
    //let modelNumber : String?
    
    enum CodingKeys: String, CodingKey {
        
        //case controls = "controls"
        //case presets = "presets"
        case id = "_id"
        //case alias = "_alias"
        //case ip = "_ip"
        //case image = "_image"
        //case port = "_port"
        //case modelNumber = "_modelNumber"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        //controls = try values.decodeIfPresent(Controls.self, forKey: .controls)
        //presets = try values.decodeIfPresent(Presets.self, forKey: .presets)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        //alias = try values.decodeIfPresent(String.self, forKey: .alias)
        //ip = try values.decodeIfPresent(String.self, forKey: .ip)
        //image = try values.decodeIfPresent(String.self, forKey: .image)
        //port = try values.decodeIfPresent(String.self, forKey: .port)
        //modelNumber = try values.decodeIfPresent(String.self, forKey: .modelNumber)
    }
}

class Cameras : Codable {
    let camera : [Camera]?
    let enabled : String?
    let icon : String?
    
    enum CodingKeys: String, CodingKey {
        
        case camera = "camera"
        case enabled = "_enabled"
        case icon = "_icon"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        camera = try values.decodeIfPresent([Camera].self, forKey: .camera)
        enabled = try values.decodeIfPresent(String.self, forKey: .enabled)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
    }
}

class Favourite : Codable {
    let id : String?
    let macro : String?
    let display : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case macro = "_macro"
        case display = "_display"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        macro = try values.decodeIfPresent(String.self, forKey: .macro)
        display = try values.decodeIfPresent(String.self, forKey: .display)
    }
}

class Menu : Codable {
    let type : String?
    let enabled : String?
    let item : [Item]?
    
    enum CodingKeys: String, CodingKey {
        case type = "_type"
        case enabled = "_enabled"
        case item = "item"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        enabled = try values.decodeIfPresent(String.self, forKey: .enabled)
        item = try values.decodeIfPresent([Item].self, forKey: .item)
    }
}

class Item : Codable {
    let serviceName : String?
    let sourceType : String?
    let icon : String?
    let type : String?
    let itemnum : String?
    let roomName : String?
    
    enum CodingKeys: String, CodingKey {
        case serviceName = "_serviceName"
        case sourceType = "_sourceType"
        case icon = "_icon"
        case type = "_type"
        case itemnum = "_itemnum"
        case roomName = "_roomName"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        serviceName = try values.decodeIfPresent(String.self, forKey: .serviceName)
        sourceType = try values.decodeIfPresent(String.self, forKey: .sourceType)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        itemnum = try values.decodeIfPresent(String.self, forKey: .itemnum)
        roomName = try values.decodeIfPresent(String.self, forKey: .roomName)
    }
}



