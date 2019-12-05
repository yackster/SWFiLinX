//
//  VCHome.swift
//  iLinX
//
//  Created by Vikas Ninawe on 30/10/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit
import CocoaAsyncSocket


class VCHome: UIViewController, UIPopoverPresentationControllerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var vwAppLogoWithInputStreams: UIView!
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var vwRooms: UIView!
    @IBOutlet weak var tblVwRooms: UITableView!
    @IBOutlet weak var tblVwControls: UITableView!
    @IBOutlet weak var collectionVwInputStreams: UICollectionView!
    @IBOutlet weak var vwDashboard: UIView!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnLog: UIButton!
    @IBOutlet var arrContainers: [UIView]!
    @IBOutlet weak var vwRoomsList: UIView!
    
    @IBOutlet weak var vwControlsList: UIView!
    
    //MARK: Timers
    weak var continuousCurrentSongTimer: Timer?
    weak var continuousConnectionTimer: Timer?
    weak var continuousRegisterTimer: Timer?
    weak var continuousRoomStatusTimer: Timer?
    weak var continuousRoomAndSourceRegisterTimer: Timer?
    
    //MARK: Flags and variables
    var arrControls = [Controls]() // Controlslist
    var connectedToIPAddress = ""
    var isOutSocketConnected = false
    var isInSocketConnected = false
    var isBroadcastSocketConnected = false
    var isAlreadyGotXMLFromNetStream = false
    var isAutomaticConnection = true
    
    var paramForPlaylist = [String: Any]()
    weak var playListVC: VCPlaylistWithPlayer?
    let queue = DispatchQueue.init(label: "com.iLinux.gettingSongs", qos: .utility)
    var isNeedToStopSongsReq = false
    //MARK: ViewController methods
    var operationQueue = OperationQueue()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set tableview delegate and datasource
        self.tblVwRooms.tag = 21
        self.tblVwRooms.delegate = self
        self.tblVwRooms.dataSource = self
        //self.tblVwRooms.isHidden = true
        self.tblVwRooms.estimatedRowHeight = 70
        self.tblVwRooms.rowHeight = UITableView.automaticDimension
        
        self.tblVwControls.tag = 22
        self.tblVwControls.delegate = self
        self.tblVwControls.dataSource = self
        self.tblVwControls.estimatedRowHeight = 70
        self.tblVwControls.rowHeight = UITableView.automaticDimension
        
        //Set collectionview delegate and datasource
        self.collectionVwInputStreams.tag = 11
        self.collectionVwInputStreams.delegate = self
        self.collectionVwInputStreams.dataSource = self
        
        // Add dropshadow with corner
        self.vwRoomsList.addShadowAllSide()
        self.vwControlsList.addShadowAllSide()
        self.vwAppLogoWithInputStreams.addShadowBottom()
        
        let notif = NotificationCenter.default
        notif.addObserver(self, selector: #selector(self.onConnect(_:)), name: .connect, object: nil)
        notif.addObserver(self, selector: #selector(self.onReconnect(_:)), name: .reconnect, object: nil)
        
        notif.addObserver(self, selector: #selector(self.updateConnectionUI(_:)), name: .socketConnectionStatus, object: nil)
        notif.addObserver(self, selector: #selector(self.updateListUI(_:)), name: .uiUpdateList, object: nil)
        
        // call socket from container view
        notif.addObserver(self, selector: #selector(self.onCallSocketFromContainer(_:)), name: .socketCallFromContainer, object: nil)
        
        // continuosly update media player
        notif.addObserver(self, selector: #selector(self.onUpdateMediaPlayer(_:)), name: .uiUpdateMediaPlayer, object: nil)
        
        notif.addObserver(self, selector: #selector(self.onConnectWhileSuspended(_:)), name: .connectWhileSuspended, object: nil)
        notif.addObserver(self, selector: #selector(self.stopTimers(_:)), name: .stopWhileSuspended, object: nil)
        
        notif.addObserver(self, selector: #selector(self.updateInputSource(_:)), name: .updateInputSource, object: nil)
        
        notif.addObserver(self, selector: #selector(self.pauseResumeRoomStatusTimer(_:)), name: .pauseResumeRoomStatusTimer, object: nil)
        notif.addObserver(self, selector: #selector(self.pauseResumeCurrentSongTimer(_:)), name: .pauseResumeCurrentSongTimer, object: nil)
        
      //  notif.addObserver(self, selector: #selector(self.updateSongList(_:)), name: .uiUpdateSongList, object: nil)
        
        self.initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
        super.viewWillDisappear(animated)
        
        let notif = NotificationCenter.default
        notif.removeObserver(self)
        
        // Stop all the timers here
        self.stopTimers(NSNotification())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        if let detailVC = segue.destination as? VCPlaylistWithPlayer {
            self.playListVC  = detailVC
            self.playListVC?.homeVC = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        //
        super.didReceiveMemoryWarning()
    }
    
    //MARK: IBActions Methods
    @IBAction func onLog(_ sender: UIButton) {
        //
        let vcLog = self.storyboard!.instantiateViewController(withIdentifier: "VCLog") as! VCLog
        vcLog.modalPresentationStyle = .overCurrentContext
        vcLog.modalTransitionStyle = .crossDissolve
        let popOver = vcLog.popoverPresentationController
        popOver?.permittedArrowDirections = .any
        popOver?.delegate = self
        popOver?.sourceView = sender
        present(vcLog, animated: false, completion: nil)
    }
    
    @IBAction func onSetting(_ sender: UIButton) {
        //
        let vcSetting = self.storyboard!.instantiateViewController(withIdentifier: "VCSetting") as! VCSetting
        vcSetting.ipAddress = self.connectedToIPAddress
        vcSetting.connectionStatusType = self.isAutomaticConnection ? "automatically".localized : "manually".localized
        vcSetting.modalPresentationStyle = .overCurrentContext
        vcSetting.modalTransitionStyle = .crossDissolve
        let popOver = vcSetting.popoverPresentationController
        popOver?.permittedArrowDirections = .any
        popOver?.delegate = self
        popOver?.sourceView = sender
        present(vcSetting, animated: false, completion: nil)
    }
    
    //MARK: Auxillary functions
    
    //Containers navigation
    func manageContainers(type:ContainerType, notificationName:Notification.Name){
        //
        for (i,_) in self.arrContainers.enumerated(){
            self.arrContainers[i].isHidden = true
        }
        self.arrContainers[type.rawValue].isHidden = false
        let notif = NotificationCenter.default
        notif.post(name: notificationName, object: nil, userInfo: nil)
    }
    
    //Initialization, arrays, sockets,...
    private func initialization(){
        //
        //Show startup screen on launch
        self.manageContainers(type: .startUp, notificationName:.uiUpdateContainerStartUp)
        
        //Arrays
        self.initializeArrays()
        
        //Connection status UI update
        self.updateConnectionStatus(self.isOutSocketConnected, socketType: .inSocket)
        self.updateConnectionStatus(self.isOutSocketConnected, socketType: .outSocket)
        
    }
    
    //Initialize all the arrays
    private func initializeArrays(){
        //
        // Initialize Controls
        for control in ModelHome.controls as [[String:String]]{
            self.arrControls.append(Controls(name:control["heading"]!.localized, isSelected:false, imageName:control["imageName"]!))
        }
    }
    
    private func restartTimers(room:String, source:String, ip:String, port:UInt16){
        //
        self.startContinuousCurrentSongTimer(source: source, ip: ip, port: port)
        self.startContinuousRoomAndSourceRegisterTimer(room: room, source: source, ip: ip, port: port)
        self.startContinuousConnectionTimer(ip: ip, port: port)
        self.startContinuousRegisterTimer(roomName:room,ip:ip, port:port)
        self.startContinuousRoomStatusTimer(roomName:room,ip:ip, port:port)
    }
    
    @objc func stopTimers(_ notification: NSNotification){
        //
        self.stopContinuousConnectionTimer()
        self.stopContinuousCurrentSongTimer()
        self.stopContinuousRegisterTimer()
        self.stopContinuousRoomStatusTimer()
        self.stopContinuousRoomAndSourceRegisterTimer()
    }
    
    @objc func onConnectWhileSuspended(_ notification: NSNotification){
        //
        self.connectToNetStream(socketType: .outSocket, userInfo: [:])
        self.connectToNetStream(socketType: .broadcast, userInfo: [:])
    }
    
    @objc func updateInputSource(_ notification: NSNotification){ // auto update input source if changed from othre device
        //
        if let sourceName = notification.userInfo?["source"] as? String{
            let rmIdx = SelectedItemDetails.roomIndex
            guard rmIdx > -1 else{return;}
            guard ModelHome.availableRooms[rmIdx].inputSources.count > 0 else{return;}
            
            for (i,source) in ModelHome.availableRooms[rmIdx].inputSources.enumerated(){
                if let sourceNameNew =  source.sourceName, sourceNameNew == sourceName{
                    let indexPath = IndexPath(item: i, section: 0)
                    DispatchQueue.main.async {
                        self.collectionVwInputStreams.delegate?.collectionView!(self.collectionVwInputStreams, didSelectItemAt:indexPath)
                    }
                    break;
                }
            }
        }
    }
    
    //Connect to Netstream system (Automatically and Manually)
    @objc func onConnect(_ notification: NSNotification){
        
        guard !self.isOutSocketConnected else{return;}
        if let isAutoConnect = notification.userInfo?["isAutoConnect"] as? Bool, isAutoConnect { // Auto connection
            self.connectedToIPAddress = ""
            self.isAutomaticConnection = true
            self.connectToNetStream(socketType: .outSocket, userInfo: [:])
        }else{ // Manual connection
            guard let manualAddress = notification.userInfo?["manualAddress"] as? String else{return}
            self.connectedToIPAddress = manualAddress
            self.isAutomaticConnection = false
            self.connectToNetStream(socketType: .outSocket, userInfo: [:])
        }
    }
    
    //ReConnect to Netstream system(Automatically and Manually)
    @objc func onReconnect(_ notification: NSNotification){
        
        guard ModelHome.availableRooms.count < 1 else{
            //self.tblVwRooms.reloadData()
            ModelHome.availableRooms = []
            return;
        }
        if let isAutoConnect = notification.userInfo?["isAutoConnect"] as? Bool, isAutoConnect {
            // Auto Reconnection
            self.connectedToIPAddress = ""
            self.isAutomaticConnection = true
            self.connectToNetStream(socketType: .outSocket, userInfo: [:])
        }else{
            // Manual Reconnection
            guard let manualAddress = notification.userInfo?["manualAddress"] as? String else{return}
            self.connectedToIPAddress = manualAddress
            self.isAutomaticConnection = false
            self.connectToNetStream(socketType: .outSocket, userInfo: [:])
        }
    }
    
    @objc func pauseResumeRoomStatusTimer(_ notification: NSNotification){
        
        if let isPause = notification.userInfo?["isPause"] as? Bool, isPause {
            self.stopContinuousRoomStatusTimer() //Pause
        }else{ //resume
            var data : [String:Any] = [:]
            data["isResume"] = true
            data["isRoomStatus"] = true
            self.connectToNetStream(socketType: .broadcast, userInfo:data)
        }
    }
    
    @objc func pauseResumeCurrentSongTimer(_ notification: NSNotification){
        
        if let isPause = notification.userInfo?["isPause"] as? Bool, isPause {
            self.tblVwControls.isUserInteractionEnabled = false
            self.stopContinuousCurrentSongTimer() // Pause
            // resume after 3 sec
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000), execute: {
                var data : [String:Any] = [:]
                data["isResume"] = true
                data["isCurrentSong"] = true
                self.connectToNetStream(socketType: .broadcast, userInfo:data)
                self.tblVwControls.isUserInteractionEnabled = true
            })
        }else{
            //Do nothing
        }
    }
    
    //Update connection status
    private func updateConnectionStatus(_ status:Bool, socketType:SocketType){
        
        switch socketType {
        case .inSocket : // incoming data over connection
            self.isInSocketConnected = status
        case .outSocket : // outgoing data over connection
            self.isOutSocketConnected = status
            if status { // very first call to recieve data for rooms
                self.connectToNetStream(socketType: .broadcast, userInfo: [:])
            }
        case .broadcast: // incoming data over connection
            self.isBroadcastSocketConnected = status
            if status{ // call once again if we successfully recieved first response
                self.connectToNetStream(socketType: .broadcast, userInfo: [:])
            }
        }
        
        //Update UI in container (Start-up container)
        var data : [String:Any] = [:]
        data["status"] = status
        data["socketType"] = socketType
        data["isAutoConnect"] = self.isAutomaticConnection
        let notif = NotificationCenter.default
        notif.post(name: .socketConnectionStatusInContainer, object: nil, userInfo: data)
    }
    
    //Connect to Netstream system via socket
    func connectToNetStream(socketType:SocketType, userInfo:[String:Any]?){
        
        switch socketType {
        case .inSocket: // call for recieving data once connection established
            InSocket.sharedInSocket.connect(ip: IP.multicastLinX.rawValue, port: Port.port8000.rawValue)
        case .outSocket: // call for establish connection between mobile app and netstream device via multicast address
            // This is Auto discovery NetStream, using multicast address + port 8000, Over UDP
            OutSocket.sharedOutSocket.connect(ip: IP.multicastLinX.rawValue, port: Port.port8000.rawValue)
        // For direct connection to NetStream, using speakerlinx, touchlinx address(port no need)
        case .broadcast: // call for recieving data once connection established
            guard let netInfo = NetworkUtilities.getIFAddresses(), netInfo.count > 0  else { // device ip and subnet mask
                self.showAlert(msg: "noIpAndSubnet".localized)
                return;
            }
            
            for i in netInfo{
                ModelHome.addLog(str: "IP: \(i.ip) and Subnet: \(i.netmask)") //@@@
            }
            
            guard let wifiAddress = NetworkUtilities.getWiFiAddress() else {
                self.showAlert(msg: "noIpAndSubnet".localized)
                return;
            }
            
            let arrSplittedWiFiAddress = (wifiAddress.split(separator: "."))
            let compareStr = arrSplittedWiFiAddress[0] + "." + arrSplittedWiFiAddress[1] // compare first 2 block
            
            ModelHome.addLog(str: "Wifi address: \(wifiAddress) and Compare string: \(compareStr)") //@@@
            
            let filteredNetInfo = netInfo.filter{$0.ip.contains(compareStr)}
            guard filteredNetInfo.count > 0 else {
                self.showAlert(msg: "noIpAndSubnet".localized)
                return;
            }
            // Broadcast address for sending data to Netstream system via port 15000
            let broadcastAddress = NetworkUtilities.calculateBroadcastAddress(ipAddress: filteredNetInfo[0].ip,
                                                                              subnetMask: filteredNetInfo[0].netmask)
            let room = SelectedItemDetails.roomName
            let oldRoom = SelectedItemDetails.oldRoomName
            let portNum = Port.port15000.rawValue
            
            //To resume continuous room status timer
            if let userInfo = userInfo, let isResume = userInfo["isResume"] as? Bool, let isRoomStatus = userInfo["isRoomStatus"] as? Bool, isResume, isRoomStatus {
                self.startContinuousRoomStatusTimer(roomName: room, ip: broadcastAddress, port: portNum)
                return;
            }
            
            //Handle connection on lock iphone (reconnect it on unlock)
            if ModelHome.connectWhileSuspended{
                BroadcastSocket.sharedBroadcastSocket.connect(ip:broadcastAddress, port:portNum)
                let source = SelectedItemDetails.inputSourceName
                self.restartTimers(room: room, source: source, ip: broadcastAddress, port: portNum)
                ModelHome.connectWhileSuspended = false
                return;
            }
            
            // Do not connect if already connected
            if ModelHome.availableRooms.count < 1 {
                BroadcastSocket.sharedBroadcastSocket.connect(ip:broadcastAddress, port:portNum)
            }
            
            var params = [String:Any]()
            params.updateValue(room, forKey: "roomName")
            params.updateValue(oldRoom, forKey: "oldRoomName")
            params.updateValue(broadcastAddress, forKey: "broadcastAddress")
            params.updateValue(portNum, forKey: "portNum")
            
            switch SelectedItemDetails.type{
            case .rooms: // get data if room gets selected (get input source and control setting)
                self.callCommandGetInputSources(params: params)
            case .inputsources: // get data if input source gets selected
                let iSource = SelectedItemDetails.inputSourceName
                let oldISource = SelectedItemDetails.oldInputSourceName
                let startC = SelectedItemDetails.start
                let endC = SelectedItemDetails.end
                let sPath = SelectedItemDetails.selectedPath
                
                //To resume continuous current song timer
                if let userInfo = userInfo, let isResume = userInfo["isResume"] as? Bool, let isCurrentSong = userInfo["isCurrentSong"] as? Bool, isResume, isCurrentSong{
                    self.startContinuousCurrentSongTimer(source: iSource, ip: broadcastAddress, port: portNum)
                    return;
                }
                
                params.updateValue(iSource, forKey: "iSource")
                params.updateValue(oldISource, forKey: "oldISource")
                params.updateValue(startC, forKey: "startC")
                params.updateValue(endC, forKey: "endC")
                params.updateValue(sPath, forKey: "sPath")
                
                var isControlState = false
                if let controlState = userInfo?["controlState"] as? Bool {
                    isControlState = controlState
                }
                
                if sPath == "" && !isControlState{ // get the first level menus of input source
                    self.callCommandGetFirstLevelMenus(params: params)
                }else{  // get the next level menus for selected item in input source menus
                    
                    switch SelectedItemDetails.elementType{
                    case .error, .report, .source, .equalizer, .restore, .none: break;
                    case .active, .currentSong, .loudness: break;
                    case .multiRoomCreate, .multiRoomJoin, .multiRoomLeave, .multiRoomCancel: break;
                    case .multiRoomAmp, .multiRoomMute, .multiRoomVolume, .multiRoomPowerOnOff: break;
                    case .favourite: break;
                    case .item:                                     // Get submenus for selected folder
                        self.callCommandGetSubMenus(params: params)
                    case .song:                                     // Select and play song
                        //self.isNeedToStopSongsReq = true    
                        let sSPath = SelectedItemDetails.selectedSongPath
                        params.updateValue(sSPath, forKey: "sSPath")
                        self.callCommandPlaySong(params: params)
                        
                    case .next:                                     // Play next song
                        self.callCommandNextSong(params: params)
                    case .prev:                                     // Play previous song
                        self.callCommandPreviousSong(params: params)
                    case .stop:                                     // Stop audio player
                        self.callCommandStopNowSong(params: params)
                    case .play:                                     // Play song if paused
                        self.callCommandPlayNowSong(params: params)
                    case .pause:                                    // Pause song if playing
                        self.callCommandPauseNowSong(params: params)
                    case .audioSetting:                             // Get audio setting for room
                        guard let userInfo = userInfo else{break;}
                        self.callCommandGetRoomCurrentSetting(userInfo:userInfo, params:params)
                    case .shuffle:                                  // toggle Shuffle
                        guard let userInfo = userInfo else{break;}
                        self.callCommandShuffleNowSong(userInfo:userInfo, params:params)
                    case .volume:                                   // Set volume for room
                        guard let userInfo = userInfo else{break;}
                        self.callCommandSetVolume(userInfo:userInfo, params:params)
                    case .mute:                                     // toggle mute/unmute
                        guard let userInfo = userInfo else{break;}
                        self.callCommandSetMute(userInfo:userInfo, params:params)
                    case .amp:                                      // toggle A/V
                        guard let userInfo = userInfo else{break;}
                        self.callCommandSetAMP(userInfo:userInfo, params:params)
                    }
                }
            case .controls: // to udpate volume, equiliser, amp, mute,...
                //To resume continuous current song timer
                
                guard let userInfo = userInfo else{break;}
                
                switch SelectedItemDetails.elementType{
                case .report, .source, .item, .error, .song, .currentSong, .none: break;
                case .active, .next, .prev, .play, .pause, .stop, .shuffle: break;
                case .equalizer:                                                    // set balance, bass, trouble, band(1,2,3,4,5)
                    self.callCommandSetEqualizer(userInfo:userInfo, params:params)
                case .restore:
                    //Please write the restore code here
                    break;
                case .volume:                                                       // set volume
                    self.callCommandSetVolume(userInfo:userInfo, params:params)
                case .mute:                                                         //toggle mute/unmute
                    self.callCommandSetMute(userInfo:userInfo, params:params)
                case .amp:                                                          // toggle A/V
                    self.callCommandSetAMP(userInfo:userInfo, params:params)
                case .audioSetting:                                                 //Get audio setting
                    self.callCommandGetRoomCurrentSetting(userInfo:userInfo, params:params)
                case .loudness:                                                     //Set presets
                    self.callCommandSetLoudnessPreset(userInfo:userInfo, params:params)
                case .multiRoomCreate:                                              // Create multiroom
                    self.callCommandCreateMultiRoom(userInfo:userInfo, params:params)
                case .multiRoomCancel:                                              // Cancel multiroom
                    self.callCommandCancelMultiRoom(userInfo:userInfo, params:params)
                case .multiRoomJoin:                                                // Join multiroom
                    guard SelectedItemDetails.inputSourceIndex > -1 else{break;}
                    let iSource = SelectedItemDetails.inputSourceName
                    params.updateValue(iSource, forKey: "iSource")
                    self.callCommandJoinMultiRoom(userInfo:userInfo, params:params)
                case .multiRoomLeave:                                               // Leave multiroom
                    self.callCommandLeaveMultiRoom(userInfo:userInfo, params:params)
                case .multiRoomVolume:                                              // Set volume for multiroom
                    self.callCommandSetMultiRoomVolume(userInfo:userInfo, params:params)
                case .multiRoomMute:                                                // toggle mute/unmute for multiroom
                    self.callCommandSetMultiRoomMute(userInfo:userInfo, params:params)
                case .multiRoomAmp:                                                 // toggle A/V for multiroom
                    self.callCommandSetMultiRoomAMP(userInfo:userInfo, params:params)
                case .multiRoomPowerOnOff:                                                 // power on/off for multiroom
                    //Please write multitroom power on/off code here
                    break;
                case .favourite:
                    self.callCommandSetFavourite(userInfo: userInfo, params: params)
                }
            case .none: // get the list of available rooms (for very first call to get rooms)
                if self.isAutomaticConnection{ // for automatic connection
                    self.callCommandGetRooms(params: params)
                }else{ //  for manual connection
                    params.updateValue(self.connectedToIPAddress, forKey: "manualAddress")
                    self.callCommandGetRoomsManually(params:params)
                }
            }
        }
    }
    
    //Update connection UI based on selected socket type on notificaiton recieved
    @objc func updateConnectionUI(_ notification: NSNotification) {
        
        if let status = notification.userInfo?["socketConnectionStatus"] as? Bool, status {
            guard let socketType = notification.userInfo?["socketType"] as? SocketType else {return;}
            switch socketType{
            case .inSocket : self.updateConnectionStatus(status, socketType: .inSocket)
            case .outSocket : self.updateConnectionStatus(status, socketType: .outSocket)
            case .broadcast : self.updateConnectionStatus(status, socketType: .broadcast)
            }
        }else if let errorMsg = notification.userInfo?["message"] as? String{
            guard errorMsg.lowercased().contains("permission") || errorMsg.lowercased().contains("socket") else{
                // Show error messages and update connection flags if necessary
                self.showAlert(msg: errorMsg)
                self.stopContinuousRegisterTimer()
                self.stopContinuousConnectionTimer()
                self.stopContinuousCurrentSongTimer()
                self.stopContinuousRoomStatusTimer()
                self.stopContinuousRoomAndSourceRegisterTimer()
                return;
            }
            return;
        }
    }
    
    //Update rooms, inputstreams and controls UI on notification recieved
    @objc func updateListUI(_ notification: NSNotification) {
        
        guard let type = notification.userInfo?["selectedItemType"] as? SelectedItemDetails.SelectedType else{ return;}
        switch type{
        case .rooms : // rooms
            DispatchQueue.main.async {
                self.tblVwRooms.reloadData()
            }
        case .inputsources: // inputstream/sources
            DispatchQueue.main.async {
                self.collectionVwInputStreams.reloadData()
            }
        case .controls: break;
        case .none: break;
        }
    }
    
    //Show alert (Common for all)
    private func showAlert(msg:String){
        
        self.presentAlertWithTitle(title:"ilinx".localized, message:msg, options:"ok".localized) { (option) in
            switch(option){
            case 0: break; //print("ok".localized)
            default: break;
            }
        }
    }
    
    //Get rooms failed pop_up
    func onGetRoomsFailed(failureMsg:String){
        //
        self.stopContinuousConnectionTimer()
        self.isAlreadyGotXMLFromNetStream = false
        ModelHome.availableRooms = []
        self.showAlert(msg: failureMsg)
    }
    
    //Start continuous current song timer (getting current status of current song)
    func startContinuousCurrentSongTimer(source:String, ip:String, port:UInt16) {
        
        self.stopContinuousCurrentSongTimer() // invalidate first and then start again
        
        self.continuousCurrentSongTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let signal = Query.getSourcePlayingSongQuery(sourceName: source)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:ip, port:port)
        }
    }
    
    //Stop continuous current song timer
    private func stopContinuousCurrentSongTimer() {
        
        self.continuousCurrentSongTimer?.invalidate()
    }
    
    //Start continuous room and source register timer
    func startContinuousRoomAndSourceRegisterTimer(room:String, source:String, ip:String, port:UInt16){
        
        self.stopContinuousRoomAndSourceRegisterTimer() // invalidate first and then start again
        self.continuousRoomAndSourceRegisterTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
                let signal = Query.getRoomCurrentSourceQuery(roomName: room)
                BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:ip, port:port)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10), execute: {
                let signal = Query.getRoomRegisterQuery(roomName: room, status: false)
                BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:ip, port:port)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20), execute: {
                let signal = Query.getRoomRendererQuery(roomName: room)
                BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:ip, port:port)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(30), execute: {
                let signal = Query.getSourceRegisterQuery(sourceName: source, status: false)
                BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:ip, port:port)
            })
        }
    }
    
    //Stop continuous room and source register timer
    private func stopContinuousRoomAndSourceRegisterTimer() {
        
        self.continuousRoomAndSourceRegisterTimer?.invalidate()
    }
    
    //Start continous connection(heartbeat) timer to keep connection alive
    func startContinuousConnectionTimer(ip:String, port:UInt16) {
        
        self.stopContinuousConnectionTimer() // invalidate first and then start again
        self.continuousConnectionTimer = Timer.scheduledTimer(withTimeInterval: 55, repeats: true) { _ in
            let signal = Query.keepConnectionLiveWithHeartBeat()
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:ip, port:port)
        }
    }
    
    //Stop continuous connection(heartbeat) timer
    private func stopContinuousConnectionTimer() {
        
        self.continuousConnectionTimer?.invalidate()
    }
    
    //Start continuous register timer to keep connection alive
    func startContinuousRegisterTimer(roomName:String,ip:String, port:UInt16) {
        
        self.stopContinuousRegisterTimer() // invalidate first and then start again
        self.continuousRegisterTimer = Timer.scheduledTimer(withTimeInterval: 25, repeats: true) { _ in
            let signal = Query.keepConnectionLiveWithRegister(roomName: roomName)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:ip, port:port)
        }
    }
    
    //Stop continous register timer
    private func stopContinuousRegisterTimer() {
        
        self.continuousRegisterTimer?.invalidate()
    }
    
    //Start continuous room status timer
    func startContinuousRoomStatusTimer(roomName:String,ip:String, port:UInt16) {
        
        self.stopContinuousRoomStatusTimer() // invalidate first and then start again
        self.continuousRoomStatusTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let signal = Query.getRoomCurrentSetting(roomName: roomName)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:ip, port:port)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                let signal = Query.getRoomCurrentSourceQuery(roomName: roomName)
                BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:ip, port:port)
            })
            // update if multiroom selected from other device
            self.tblVwRooms.reloadData()
        }
    }
    
    //Stop continous room status timer
    private func stopContinuousRoomStatusTimer() {
        
        self.continuousRoomStatusTimer?.invalidate()
    }
    
    //Socket call from container view on notification recieved
    @objc func onCallSocketFromContainer(_ notification: NSNotification) {
        self.connectToNetStream(socketType:.broadcast, userInfo: notification.userInfo as? [String : Any])
    }
    
    //Continuously update media player
    @objc func onUpdateMediaPlayer(_ notification: NSNotification) {
        
        self.connectToNetStream(socketType:.broadcast, userInfo: notification.userInfo as? [String : Any])
    }
    
    //Call this command from get input sources to keep connection alive
    func callCommandKeepConnectionAliveWithRegister(roomName:String, ip:String, port:UInt16) {
        self.startContinuousRegisterTimer(roomName:roomName, ip: ip, port: port)
    }
    
    //Call this function from getrooms to keep connection alive
    func callCommandKeepConnectionAlive(ip:String, port:UInt16) {
        self.startContinuousConnectionTimer(ip: ip, port: port)
    }
}
