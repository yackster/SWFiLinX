//
//  SocketInterface.swift
//  iLinX
//
//  Created by Vikas Ninawe on 26/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

enum IP : String{
    case empty = "0.0.0.0" // empty ip
    case localHost = "127.0.0.1" // localhost ip
    case multicastLinX = "239.255.16.90" // streamnet system multicast ip
    case debugMulticastLinX = "239.255.16.21" // // streamnet system debug multicast ip
    case redbytes = "192.168.0.1" // redbytes router ip
}

enum Port : UInt16{
    case port0 = 0
    case port80 = 80 // default port
    case port8080 = 8080 // default port
    case port8000 = 8000 // Auto Discovery port
    case port15000 = 15000 // ASCII port for streamnet, recommended
    case port7000 = 7000 // deafult ip port for streamnet
    case port5001 = 5001 // streamnet system multicast default port
    case port5000 = 5000
    case port9000 = 9000 // streamnet system debug multicast port
}

enum SocketType :String{
    case inSocket = "insocket" // for recieving
    case outSocket = "outsocket" // for sending
    case broadcast = "broadcast" // for broadcasting
}

extension Notification.Name {
    
    //Home
    static let socketConnectionStatus = Notification.Name("socketConnectionStatus")
    static let socketCallFromContainer = Notification.Name("socketCallFromContainer")
    static let uiUpdateMediaPlayer = Notification.Name("uiUpdateMediaPlayer")
    static let showErrorPopUp = Notification.Name("showErrorPopUp")
    static let uiUpdateContainerSelectedRoomDetails = Notification.Name("uiUpdateContainerSelectedRoomDetails")
    static let uiUpdateList = Notification.Name("uiUpdateList")
    static let pauseResumeRoomStatusTimer = Notification.Name("pauseResumeRoomStatusTimer")
    
    //StartUp
    static let uiUpdateContainerStartUp = Notification.Name("uiUpdateContainerStartUp")
    static let connect = Notification.Name("connect")
    static let reconnect = Notification.Name("reconnect")
    static let connectWhileSuspended = Notification.Name("connectWhileSuspended")
    static let stopWhileSuspended = Notification.Name("stopWhileSuspended")
    static let socketConnectionStatusInContainer = Notification.Name("socketConnectionStatusInContainer")
    static let updateInputSource = Notification.Name("updateInputSource")
    
    //PlaylistWithPlayer
    static let uiUpdateContainerPlaylistWithPlayer = Notification.Name("uiUpdateContainerPlaylistWithPlayer")
    static let uiUpdateSongList = Notification.Name("uiUpdateSongList")
    static let uiUpdateAVPlayer = Notification.Name("uiUpdateAVPlayer")
    static let pauseResumeCurrentSongTimer = Notification.Name("pauseResumeCurrentSongTimer")
    
    
    //Media Setting
    static let uiUpdateContainerMediaSetting = Notification.Name("uiUpdateContainerMediaSetting")
    static let uiUpdateSetting = Notification.Name("uiUpdateSetting")
    
    //AudioVideo Source
    static let uiUpdateContainerAudioVideoSource = Notification.Name("uiUpdateContainerAudioVideoSource")
    
    //MultiRoom
    static let uiUpdateContainerMultiroomOption = Notification.Name("uiUpdateContainerMultiroomOption")
    
    //General
    static let uiUpdateLog = Notification.Name("uiUpdateLog")
    static let resumePauseQueue = Notification.Name("resumePauseQueue")
    static let UiUpdateTable = Notification.Name("UiUpdateTable")
}

// Receiving
final class InSocket: NSObject, GCDAsyncUdpSocketDelegate {
    
    static let sharedInSocket = InSocket()
    
    var socket:GCDAsyncUdpSocket!
    
    var recievedData = Data()
    static var isReceivingForFirstTime = false
    
    override init(){
        super.init()
        //self.connect()
    }
    
    init(ip:String, port:UInt16) {
        super.init()
        self.connect(ip: ip, port: port)
    }
    
    func connect(ip:String, port:UInt16){
        //
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue:DispatchQueue.main)
        do {
            try socket.bind(toPort: port)
        } catch {
            print("InSocket: Unable to bind to port \(port)")
        }
        do {
            try socket.enableBroadcast(true)
        } catch {
            print("InSocket: Unable to broadcast from \(ip):\(port)")
        }
        do {
            try socket.joinMulticastGroup(ip)
        } catch {
            print("InSocket: Unable to join MulticastGroup to \(ip):\(port)")
        }
        do {
            try socket.beginReceiving()
        } catch {
            print("InSocket: Unable to begin Receiving from \(ip):\(port)")
        }
        socket.setMaxSendBufferSize(32756)
        socket.setMaxReceiveIPv4BufferSize(32756)
        socket.setMaxReceiveIPv6BufferSize(32756)
    }
    
    //MARK:-GCDAsyncUdpSocketDelegate
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        
        //print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& InSocket- didReceive &&&&&&&&&&&&&&&&")
        // Find a valid message; that is, #@...#...\0
        print("incoming message InSocket: \(data)");
        
        if let string = String(bytes: data, encoding: .ascii) {
            //print("Recieved string InSocket: ",string)
        } else {
            //print("not a valid ASCII sequence")
        }
        
        if self.recievedData.count >= (1024*3){
            //if let string = String(bytes: self.recievedData, encoding: .ascii) {
                //print("DecodedString InSocket: ", string)
            //}
            self.recievedData = Data()
            self.recievedData.append(data)
        }else{
            self.recievedData.append(data)
        }
        print("incoming message: \(data)");
        let signal:Signal = Signal.unarchive(d: data)
        print("signal information : \n first \(signal.firstSignal) , second \(signal.secondSignal) \n third \(signal.thirdSignal) , fourth \(signal.fourthSignal)") //print("*************************************************************************************************")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        //
        if let _error = error {
            //print("InSocket: didNotConnect \(_error )")
            let _ = PostNotification.init(status: false, message: _error.localizedDescription, socketType: .inSocket)
            ModelHome.addLog(str: "InSocket: didNotConnect \(_error)") //@@@
        }
    }
    
    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        //
        if let _error = error {
            //print("InSocket: withError \(_error )")
            let _ = PostNotification.init(status: false, message: _error.localizedDescription, socketType: .inSocket)
            ModelHome.addLog(str: "InSocket: didClose withError \(_error)") //@@@
        }
    }
}


//Sending
final class OutSocket: NSObject, GCDAsyncUdpSocketDelegate {
    
    static let sharedOutSocket = OutSocket()
    
    var socket:GCDAsyncUdpSocket!
    
    override init(){
        super.init()
    }
    
    init(ip:String, port:UInt16) {
        super.init()
        self.connect(ip: ip, port: port)
    }
    
    func connect(ip:String, port:UInt16){
        //
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
            try socket.bind(toPort: port)
        } catch {
            print("OutSocket: Unable to bind to port \(port)")
        }
        do {
            try socket.connect(toHost:ip, onPort: port)
        } catch {
            print("OutSocket: Unable to join MulticastGroup to \(ip):\(port)")
        }
        do {
            try socket.beginReceiving()
        } catch {
            print("OutSocket: Unable to begin Receiving from \(ip):\(port)")
        }
    }
    
    func send(signalStr:String){
        //
        //print("Sent string OutSocket: \(signalStr)")
        do {
            try socket.enableBroadcast(true)
        } catch {
          //  print("OutSocket: Unable to begin Receiving from \(ip):\(port)")
        }
       
      let signalData = signalStr.data(using: .utf8)
        socket.send(signalData!, withTimeout: 1000, tag:0)
    }
    
    //MARK:- GCDAsyncUdpSocketDelegate
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        //
        //print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& OutSocket- didReceive &&&&&&&&&&&&&&&&")
        if let string = String(bytes: data, encoding: .ascii) {
            //print("Recieved string OutSocket: ",string)
        } else {
            //print("not a valid ASCII sequence")
        }
        //print("*************************************************************************************************")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        //print("OutSocket: didConnectToAddress")
        //
        let _ = PostNotification.init(status: true, message: "Success!", socketType: .outSocket)
    }
 
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        if let _error = error {
            //
            //print("OutSocket: didNotConnect \(_error )")
            let _ = PostNotification.init(status: false, message: _error.localizedDescription, socketType: .outSocket)
            ModelHome.addLog(str: "OutSocket: didNotConnect \(_error )")  //@@@
        }
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        //
        if let _error = error {
            //print("OutSocket: didNotSendDataWithTag \(_error)")
        }
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        //
        //print("OutSocket: didSendDataWithTag")
    }
    
    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        //
        if let _error = error {
            //print("OutSocket: withError \(_error )")
            let _ = PostNotification.init(status: false, message: _error.localizedDescription, socketType: .outSocket)
            ModelHome.addLog(str: "OutSocket: didClose withError \(_error)") //@@@
        }
    }
}


// Broadcasting
final class BroadcastSocket: NSObject, GCDAsyncUdpSocketDelegate {
    
    static let sharedBroadcastSocket = BroadcastSocket()
    var socket:GCDAsyncUdpSocket!
    static var isReceivingForFirstTime = false
    var recievedData = Data()
    
    override init(){
        super.init()
        //self.connect()
    }
    
    init(ip:String, port:UInt16) {
        super.init()
        self.connect(ip: ip, port: port)
    }
    
    func connect(ip:String, port:UInt16){
        //
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue:DispatchQueue.main)
        do {
            try socket.bind(toPort: port)
        } catch {
            //print("BroadcastSocket: Unable to bind to port \(port)")
        }
        do {
            try socket.enableBroadcast(true)
        } catch {
            //print("BroadcastSocket: Unable to broadcast from \(ip):\(port)")
        }
        do {
            try socket.joinMulticastGroup(ip)
        } catch {
            print("BroadcastSocket: Unable to join MulticastGroup to \(ip):\(port)")
        }
        do {
            try socket.beginReceiving()
        } catch {
            print("BroadcastSocket: Unable to begin Receiving from \(ip):\(port)")
        }
    }
  
    //MARK:-GCDAsyncUdpSocketDelegate
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
    //
        // Find a valid message; that is, #@...#...\0
        //print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& BroadcastSocket- didReceive &&&&&&&&&&&&&&&&")
        if let string = String(bytes: data, encoding: .ascii) {
            print("Recieved string BroadcastSocket: ",string)
            //@@@
            if string.contains("controlState") && string.contains("genre") && string.contains("album") && string.contains("artwork"){
               // dont add log for current song status
            }else if string.contains("#QUERY SOURCE") || string.contains("#HEARTBEAT") || string.contains("#REGISTER"){
                // dont add log for query source and heartbeat and register
            }else{
                ModelHome.addLog(str: string) //@@@
            }
        } else {
            //print("not a valid ASCII sequence")
        }
        
        // Do not add unneccessary data for precessing
       // guard data.count > 55 else { return; }
        
       // print("Incoming message from BroadcastSocket: \(data)");
        if let string = String(bytes: data, encoding: .ascii) {
            //print("Recieved string from BroadcastSocket: ", string)
            
            //For fast processing
            // only for current playing song information, refresh as soon as song data recieved
            if string.contains("sngPlTotal") && string.contains("sngPlIndex"){
                //print("Recieved string from BroadcastSocket sngPlTotal & sngPlIndex: ", string)
                ModelHome.extractData(str: string)
                return;
            }else if string.contains("DHCP_EN") && string.contains("staticIP_EN"){ // to get the network query data
                ModelHome.extractData(str: string)
                return;
            }else if string.contains("Player#REPORT"){ // refresh room list as soon as room data recieved
                ModelHome.extractData(str: string)
                return;
            }else if string.contains("Player#MENU_RESP"){ // refresh input source list as soon as source data recieved
                ModelHome.extractData(str: string)
                return;
            }else if string.contains("error"){ // to pop error as soon as it comes
                ModelHome.extractData(str: string)
                return;
            }
        } else {
            //print("not a valid ASCII sequence")
        }
        
        // for usual processing
       // print("received data count is \(self.recievedData.count)")
        if self.recievedData.count >= (5){ // 512 // 1024
            if let string = String(bytes: self.recievedData, encoding: .ascii) {
                //print("DecodedString from BroadcastSocket: ", string)
                ModelHome.extractData(str: string)
            }
            self.recievedData = Data()
            self.recievedData.append(data)
        }else{
            self.recievedData.append(data)
        }
        
        //print("*************************************************************************************************")
    }
    enum Result<T> {
        case success(T)
        case error(String)
    }
    
    func send12323(signalStr:String, ipAddress:String, port:UInt16, complection: @escaping(Result<[Media]>)->()){
        //
        //
        print("Sent string BroadcastSocket: \(signalStr)")
        let group = DispatchGroup()
        group.enter()
        let signalData = signalStr.data(using: .utf8)
        socket.send(signalData!,toHost:ipAddress, port: port, withTimeout: 5, tag: 0)
        group.leave()
        complection(.success([]))
    }
    
    func send(signalStr:String, ipAddress:String, port:UInt16){
        //
        //
        print("Sent string BroadcastSocket send: \(signalStr)")
      
        let signalData = signalStr.data(using: .utf8)
        socket.send(signalData!,toHost:ipAddress, port: port, withTimeout: -1, tag: 0)
    
    }
   
   
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        //
        if let _error = error {
            //print("BroadcastSocket: didNotConnect \(_error )")
            let _ = PostNotification.init(status: false, message: _error.localizedDescription, socketType: .broadcast)
            ModelHome.addLog(str: "BroadcastSocket: didNotConnect \(_error )") //@@@
        }
    }
    
    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        //
        if let _error = error {
            //print("BroadcastSocket: withError \(_error )")
            let _ = PostNotification.init(status: false, message: _error.localizedDescription, socketType: .broadcast)
            ModelHome.addLog(str: "BroadcastSocket: didClose withError \(_error)")  //@@@
        }
    }
}

class PostNotification{
    
    init(){
        let notif = NotificationCenter.default
        notif.post(name: .uiUpdateSongList, object: nil, userInfo: [:]) // update songs list
    }
    
    init(room:String, source:String) {
        var data = [String:Any]()
        data.updateValue(room, forKey: "room")
        data.updateValue(source, forKey: "source")
        let notif = NotificationCenter.default
        notif.post(name: .uiUpdateAVPlayer, object: nil, userInfo: data) // update audio player
    }
    
    init(error: String){
        var data = [String:Any]()
        data.updateValue(error, forKey: "error")
        let notif = NotificationCenter.default
        notif.post(name: .showErrorPopUp, object: nil, userInfo: data) // show error pop up
    }
    
    init(status: Bool, message: String, socketType: SocketType){
        var data = [String:Any]()
        data.updateValue(status, forKey: "socketConnectionStatus")
        data.updateValue(socketType, forKey: "socketType")
        data.updateValue(message, forKey: "message")
        let notif = NotificationCenter.default
        notif.post(name: .socketConnectionStatus, object: nil, userInfo: data) // update connection status with UI
    }
    
    init(selectedType: SelectedItemDetails.SelectedType){
        var data = [String:Any]()
        data.updateValue(selectedType, forKey: "selectedItemType")
        let notif = NotificationCenter.default
        notif.post(name: .uiUpdateList, object: nil, userInfo: data) // update rooms n inputsource list
    }
    
    init(source:String){
        var data = [String:Any]()
        data.updateValue(source, forKey: "source")
        let notif = NotificationCenter.default
        notif.post(name: .updateInputSource, object: nil, userInfo: data) // show error pop up
    }
}


