//
//  SongOperations.swift
//  iLinX
//
//  Created by Vikas Ninawe on 22/08/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//

import Foundation
enum songRecordState {
    case new, download, filtered, failed
}
class songRecord: Appendable {
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
class pendingOperation {
    lazy var downloadInProgress: [IndexPath : Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Song download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var filtrationsInProgress: [IndexPath: Operation] = [:]
    lazy var filtrationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Song Filtration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}
