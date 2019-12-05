//
//  ExtensionVCHome.swift
//  iLinX
//
//  Created by Vikas Ninawe on 27/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

extension VCHome: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //MARK: Collection view methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          
        switch collectionView.tag {
        case 11: // InputStreams / sources
            let rmIdx = SelectedItemDetails.roomIndex
            return (rmIdx >= 0) ? ModelHome.availableRooms[rmIdx].inputSources.count : 0
        default:
            return 0;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
        switch collectionView.tag {
        case 11: // InputStreams / sources
            let rmIdx = SelectedItemDetails.roomIndex
            let cellInputStreamsCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "CellInputStreamsCollectionView", for: indexPath) as! CellInputStreamsCollectionView
            cellInputStreamsCollectionView.setValues(values: ModelHome.availableRooms[rmIdx].inputSources[indexPath.item])
            return cellInputStreamsCollectionView;
        default:
            return UICollectionViewCell();
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          
        switch collectionView.tag {
        case 11:
            // InputStreams
            // sources
            let frm = self.collectionVwInputStreams.frame
            return CGSize(width:frm.width*0.25, height:frm.height);
        default:
            return CGSize.zero;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView.tag {
            
        case 11: // InputStreams / Sources
            let rmIdx = SelectedItemDetails.roomIndex
            for (i,source) in ModelHome.availableRooms[rmIdx].inputSources.enumerated(){
                source.isSelected = (i == indexPath.item) ? true : false
                
                if i == indexPath.item {
                    
                    if let hint = collectionView.accessibilityHint, hint == "automatic"{
                        //Do nothing
                    }else{
                        guard SelectedItemDetails.inputSourceIndex != i else{ // Do nothing if inputsource is already selected
                            return;
                        }
                    }
                    
                    // Save old selected inputSoruce
                    let oinsr = SelectedItemDetails.oldInputSourceName
                    let insr = SelectedItemDetails.inputSourceName
                    
                    if (oinsr == "") || (oinsr != insr){
                        SelectedItemDetails.oldInputSourceName = insr
                    }
                    
                    // Update selected inputsource to SelectedItemDetails and call socket
                    SelectedItemDetails.inputSourceName = source.sourceName!
                    SelectedItemDetails.type = .inputsources
                    SelectedItemDetails.inputSourceIndex = indexPath.item
                    
                    // pause/resume current song timer on input source change
                    var data : [String:Any] = [:]
                    data["isPause"] = true
                    let notif = NotificationCenter.default
                    notif.post(name: .pauseResumeCurrentSongTimer, object: nil, userInfo: data)
                    
                    // Call only if input source selected as Off
                    if source.displaySourceName?.lowercased() == "off"{
                        let _ = PostNotification.init(room: SelectedItemDetails.roomName, source:source.sourceName!)
                        if playListVC != nil {
                            playListVC?.items.removeAll()
                            playListVC?.cellSongListTableView.reloadData()
                        }
                    }
                    
                    //Check if it is called programatically
                    if let hint = collectionView.accessibilityHint, hint == "automatic"{
                        collectionView.accessibilityHint = nil
                        SelectedItemDetails.selectedPath = ModelHome.availableRooms[rmIdx].selectedPath!
                    }else{
                        SelectedItemDetails.selectedPath = ""
                        ModelHome.availableRooms[rmIdx].selectedPath = SelectedItemDetails.selectedPath
                    }
                    
                    // number of childs/subfolders available
                    SelectedItemDetails.start = DefaultValues.startcount
                    if let noOfChildrens = source.sourceSetting?.children{
                        SelectedItemDetails.end = (noOfChildrens == "0") ? DefaultValues.endCount : noOfChildrens
                    }else{
                        SelectedItemDetails.end = DefaultValues.endCount
                    }
                    SelectedItemDetails.selectedSongPath = ""
                    SelectedItemDetails.elementType = .none
                    self.connectToNetStream(socketType: .broadcast, userInfo: [:])
                }
            }
            self.collectionVwInputStreams.reloadData()
            
            // show source playlist with player
            self.manageContainers(type: .playlistWithPlayer, notificationName:.uiUpdateContainerPlaylistWithPlayer)
            
        default:
            break;
        }
        
        if let playListVC = self.playListVC, playListVC.timerToGetSongs != nil {
            playListVC.timerToGetSongs?.invalidate()
        }
    }
}


//MARK: Room list
extension VCHome: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: Tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        switch tableView.tag {
            
        case 21: // rooms tableview
            return ModelHome.availableRooms.count;
        case 22: // cotrols tableview
            return (ModelHome.availableRooms.count > 0) ? self.arrControls.count : 0
        default:
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        switch tableView.tag {
            
        case 21: // Rooms
            let cellRoomsTableView = tableView.dequeueReusableCell(withIdentifier: "CellRoomsTableView", for: indexPath) as! CellRoomsTableView
            cellRoomsTableView.setValues(values: ModelHome.availableRooms[indexPath.row])
            cellRoomsTableView.selectionStyle = .none
            return cellRoomsTableView;
        case 22: // Controls
            let cellControlsTableview = tableView.dequeueReusableCell(withIdentifier: "CellControlsTableview", for: indexPath) as! CellControlsTableview
            
            cellControlsTableview.setValues(values: self.arrControls[indexPath.row])
            cellControlsTableview.btnControl.addTarget(self, action: #selector(self.onControls(_:)), for: .touchUpInside)
            cellControlsTableview.btnControl.tag = indexPath.row
            cellControlsTableview.selectionStyle = .none
            return cellControlsTableview;
        default:
            return UITableViewCell();
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVwControls {
            if indexPath.row == 0 {
                return 0
            }else{
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView.tag {
            
        case 21: // Rooms
            var isFound = false
            for (i,_) in ModelHome.availableRooms.enumerated(){
                ModelHome.availableRooms[i].isSelected = (i == indexPath.row) ? true : false
                
                if i == indexPath.row{
                    guard SelectedItemDetails.roomIndex != i else{ // Do nothing if room is already selected
                        return;
                    }
                    
                    let orm = SelectedItemDetails.oldRoomName
                    let rm = SelectedItemDetails.roomName
                    
                    // Save old selected room
                    if (orm == "") || (orm != rm){
                        SelectedItemDetails.oldRoomName = rm
                    }
                    // Update selected room to SelectedItemDetails and call socket
                    SelectedItemDetails.roomName = ModelHome.availableRooms[i].roomName!
                    SelectedItemDetails.type = .rooms
                    SelectedItemDetails.roomIndex = indexPath.row
                    
                    //check if inputsource is selected while switching rooms
                    for (k,source) in ModelHome.availableRooms[i].inputSources.enumerated(){
                        if (source.isSelected!){
                            isFound = true
                            SelectedItemDetails.inputSourceIndex = k //reset selected input source index on room change
                            SelectedItemDetails.inputSourceName = source.sourceName! //reset selected input source name on room change
                        }
                    }
                    if !isFound{
                        SelectedItemDetails.inputSourceIndex = -1 //reset selected input source index on room change
                        SelectedItemDetails.inputSourceName = "" //reset selected input source name on room change
                    }
                    
                    SelectedItemDetails.selectedPath = ModelHome.availableRooms[i].selectedPath! //reset selected path on room change
                    SelectedItemDetails.start = DefaultValues.startcount //default start index
                    SelectedItemDetails.end = DefaultValues.endCount //default end index
                    SelectedItemDetails.selectedSongPath = ""
                    SelectedItemDetails.elementType = .none
                    self.connectToNetStream(socketType: .broadcast, userInfo: [:])
                }
            }
            self.tblVwRooms.reloadData()
            
            // reset controls tableview
            self.tblVwControls.reloadData()
            
            // reset inputstream collectionview
            self.collectionVwInputStreams.reloadData()
            
            // show selected rooms playground
            self.manageContainers(type: .selectedRoomDetails, notificationName:.uiUpdateContainerSelectedRoomDetails)
            
            // show source playlist with player (applicable, if source changed on any other device)
            if isFound{ //(Auto call for input source selection collection view)
                let indexPath = IndexPath(item: SelectedItemDetails.inputSourceIndex, section: 0)
                self.collectionVwInputStreams.accessibilityHint = "automatic"
                self.collectionView(self.collectionVwInputStreams, didSelectItemAt:indexPath)
            }
            
        case 22: // Controls
            break;
        default:
            break;
        }
    }
}

extension VCHome : PopOver{
    
    func onPop(info: ComposedType?) {
          
        SelectedItemDetails.elementType = info?.0 ?? .none
        SelectedItemDetails.type = info?.1 ?? .none
        
        for (i,_) in self.arrControls.enumerated(){
            self.arrControls[i].isSelected = false
        }
        self.tblVwControls.reloadData()
    }
    
    func onAudioVideoSource(_ sender: UIButton, _ info:ComposedType){
          
        let vcAudioVideoSource = self.storyboard!.instantiateViewController(withIdentifier: "VCAudioVideoSource") as! VCAudioVideoSource
        vcAudioVideoSource.popDelegate = self
        vcAudioVideoSource.info = info
        vcAudioVideoSource.modalPresentationStyle = .overCurrentContext
        vcAudioVideoSource.modalTransitionStyle = .crossDissolve
        let popOver = vcAudioVideoSource.popoverPresentationController
        popOver?.permittedArrowDirections = .any
        popOver?.delegate = self
        popOver?.sourceView = sender
        present(vcAudioVideoSource, animated: false, completion: nil)
    }
    
    func onAudioMediaSetting(_ sender: UIButton, _ info:ComposedType){
          
        let vcMediaSetting = self.storyboard!.instantiateViewController(withIdentifier: "VCMediaSetting") as! VCMediaSetting
        vcMediaSetting.popDelegate = self
        vcMediaSetting.info = info
        vcMediaSetting.modalPresentationStyle = .overCurrentContext
        vcMediaSetting.modalTransitionStyle = .crossDissolve
        let popOver = vcMediaSetting.popoverPresentationController
        popOver?.permittedArrowDirections = .any
        popOver?.delegate = self
        popOver?.sourceView = sender
        
        
        present(vcMediaSetting, animated: false, completion: nil)
    }
    
    func onMultiRoomOption(_ sender: UIButton, _ info:ComposedType){
          
        let vcMultiroomOption = self.storyboard!.instantiateViewController(withIdentifier: "VCMultiroomOption") as! VCMultiroomOption
        vcMultiroomOption.popDelegate = self
        vcMultiroomOption.info = info
        vcMultiroomOption.modalPresentationStyle = .overCurrentContext
        vcMultiroomOption.modalTransitionStyle = .crossDissolve
        let popOver = vcMultiroomOption.popoverPresentationController
        popOver?.permittedArrowDirections = .any
        popOver?.delegate = self
        popOver?.sourceView = sender
        present(vcMultiroomOption, animated: false, completion: nil)
    }
    
    @objc func onControls(_ sender: UIButton){
          
        let info = (SelectedItemDetails.elementType, SelectedItemDetails.type)
        
        switch sender.tag{
        case 0: // Audio/Video Source
            self.onAudioVideoSource(sender, info)
        case 1: // Media/Audio Setting
            self.onAudioMediaSetting(sender, info)
        case 2: // Multirooms Options
            self.onMultiRoomOption(sender, info)
        default:
            break;
        }
        
        // Update UI of control tableview
        for (i,_) in self.arrControls.enumerated(){
            self.arrControls[i].isSelected = (i == sender.tag) ? true : false
            
            if i == sender.tag{ // update SelectedItemDetails on control selection
                SelectedItemDetails.elementType = .none
                SelectedItemDetails.type = .controls
            }
        }
        self.tblVwControls.reloadData()
    }
}

extension VCHome{
    
    //MARK: Rooms/InputSource control command
    
    //Get network IPs to get rooms along with their inputsources, ie. get XML file from NetStreams
    func callCommandGetNetworkIPs(params:[String:Any]){
          
        let roomName = params["roomName"] as! String // IpodRoom Player, Room 2 Player
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getNetworkQuery(roomName: roomName)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
            //let signal = Query.getAllFriendSolicitQuery(ip: IP.multicastLinX.rawValue, port: Port.port8000.rawValue)
            //BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
    }
    
    //Select and play song
    func callCommandPlaySong(params:[String:Any]){
          
        let roomName = params["roomName"] as! String
        let iSource = params["iSource"] as! String
        let sSPath = params["sSPath"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getSourceSelectedQuery(roomName:roomName, sourceName:iSource)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10), execute: {
            let signal = Query.getPathSelectedQuery(sourceName:iSource, path:sSPath )
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        // Get current playing song details after 1 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            let signal = Query.getSourcePlayingSongQuery(sourceName: iSource)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(650), execute: {
            let noti = NotificationCenter.default
            noti.post(name: .resumePauseQueue, object: nil, userInfo: nil)
            self.hideHUD(isAnimated: true)
        })
    }
    func callCommandGetSubMenus1(params:[String:Any]){
          
        let roomName = params["roomName"] as! String
        let iSource = params["iSource"] as! String
        let startC = params["startC"] as! String
        let endC = params["endC"] as! String
        let sPath = params["sPath"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        let oldISource = params["oldISource"] as! String
        
        let startCount:Int = Int(startC)!
        //let endCount: Int  = Int(endC)!
        let maxEnd:Int = Int (endC)!
        var counterStart = startCount
        let counterEnd = counterStart
        
        if counterStart < 2, let playListVC = self.playListVC, playListVC.arrMedias.count > 10 {
             counterStart = playListVC.arrMedias.count - 2
            debugPrint("Existing  Array Count : ", playListVC.arrMedias.count)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            guard let ampOnStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn else{return;}
            guard ampOnStatus == "0" else{return;} // evry time input source selected, amp on
            ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn = "1"
            let signal = Query.getAmpOnOffQuery(roomName:roomName, status:false) // false, make it ON, toggling
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10), execute: {
            let signal = Query.getSourceSelectedQuery(roomName:roomName, sourceName: iSource)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20), execute: {
            guard oldISource != "" else{return;}
            let signal = Query.getSourceRegisterQuery(sourceName: oldISource, status: true) // OFF old inputsource
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(30), execute: {
            let signal = Query.getSourceRegisterQuery(sourceName: iSource, status: false) // ON new inputsource
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(40), execute: {
            let signal = Query.getSourcePlayingSongQuery(sourceName: iSource)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: {
            self.startContinuousCurrentSongTimer(source:iSource, ip:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(60), execute: {
            self.startContinuousRoomAndSourceRegisterTimer(room:roomName, source:iSource, ip:broadcastAddress, port:portNum)
        })
       
//         DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(80), execute: {
//            let group = DispatchGroup()
//            group.enter()
//        let signal = Query.getSourceMenuListForPathQuery(   sourceName:iSource,
//                                                            path:sPath,
//                                                            start: String(startC),
//                                                            end: String(maxEnd))
//            group.leave()
//      //      group.notify(queue: DispatchQueue.main, work: _ed)
//        BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
//            group.leave()
//        //self.getSubFolder(startIndex: counterStart, endIndex: counterEnd, roomName: roomName, broadcastAddress: broadcastAddress, portNum: portNum, sPath: sPath, iSource: iSource, oldISource: oldISource, maxEnd: maxEnd)
//        })
        self.getSubFolder(startIndex: counterStart, endIndex: counterEnd, roomName: roomName, broadcastAddress: broadcastAddress, portNum: portNum, sPath: sPath, iSource: iSource, oldISource: oldISource, maxEnd: maxEnd)
    }
    func getSubFolder(startIndex:Int, endIndex:Int, roomName:String, broadcastAddress:String, portNum:UInt16, sPath:String, iSource:String, oldISource:String, maxEnd:Int){
          
        print("List of Notifcation observer \(String(describing: NotificationCenter.observationInfo()))")
        self.showHUD(progressLabel: "fetching".localized)
        printDateTime()
        
        let songDownloadQueue = OperationQueue()
        songDownloadQueue.maxConcurrentOperationCount = 1
        let blockOperationForSongDownloads = BlockOperation()
        var counterStart = startIndex
        //var counterEnd = endIndex
        let notif = NotificationCenter.default
        for index in counterStart..<maxEnd
        {
            print("Batch 1 - Song \(index) queued for download")
            blockOperationForSongDownloads.addExecutionBlock
            {
                var signal: String?
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10), execute: {
                    signal = Query.getSourceMenuListForPathQuery(sourceName:iSource,
                                                                 path:sPath,
                                                                 start: String(index),
                                                                 end: String(index + 1))
                    BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal!, ipAddress:broadcastAddress, port:portNum)
                })
            
            }
            songDownloadQueue.addOperation {
                print("Batch 1 - Song \(index) has downloaded")
                counterStart += 1
                notif.post(name: .uiUpdateSongList, object: nil, userInfo: nil)
            }
        }
        songDownloadQueue.waitUntilAllOperationsAreFinished()
        songDownloadQueue.addOperation(blockOperationForSongDownloads)
        self.hideHUD(isAnimated: true)
    }
    func printDateTime() -> Void
    {
          
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss:SSS"
        
        let result = formatter.string(from: date)
        
        print(result)
    }
  
    /*func getSubFolder1(startIndex:Int, endIndex:Int, roomName:String, broadcastAddress:String, portNum:UInt16, sPath:String, iSource:String, oldISource:String, maxEnd:Int){
        print("startIndex",startIndex,"   ","endIndex",endIndex)
        self.showHUD(progressLabel: "fetching".localized)
        
        var counterStart = startIndex
        var counterEnd = endIndex
        
        DispatchQueue.main.async {
            let signal = Query.getSourceMenuListForPathQuery(   sourceName:iSource,
                                                                path:sPath,
                                                                start: String(startIndex),
                                                                end: String(endIndex))
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum) { (res) in
                switch res {
                case .success(let obj):
                    debugPrint(obj.count)
                    if (counterEnd < maxEnd){
                        counterStart = counterEnd
                        counterEnd = counterStart + 7
                        self.getSubFolder(startIndex: counterStart, endIndex: counterEnd, roomName: roomName, broadcastAddress: broadcastAddress, portNum: portNum, sPath: sPath, iSource: iSource, oldISource: oldISource, maxEnd: maxEnd)
                        
                    } else {
                        self.hideHUD(isAnimated: true)
                        
                    }
                case .error(let strerror):
                    debugPrint(strerror)
                }
            }
        }
        /*  DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
         let signal = Query.getSourceMenuListForPathQuery(   sourceName:iSource,
         path:sPath,
         start: String(startIndex),
         end: String(endIndex))
         BroadcastSocket.sharedBroadcastSocket.send1(signalStr:signal, ipAddress:broadcastAddress, port:portNum) { (res) in
         switch res {
         case .success(let obj):
         debugPrint(obj.count)
         if (counterEnd < maxEnd){
         counterStart = counterEnd
         counterEnd = counterStart + 7
         
         self.getSubFolder(startIndex: counterStart, endIndex: counterEnd, roomName: roomName, broadcastAddress: broadcastAddress, portNum: portNum, sPath: sPath, iSource: iSource, oldISource: oldISource, maxEnd: maxEnd)
         
         }
         else{
         self.hideHUD(isAnimated: true)
         }
         case .error(let strerror):
         debugPrint(strerror)
         }
         }
         })*/
        /* DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1040), execute: {
         if (counterEnd < maxEnd){
         counterStart = counterEnd
         counterEnd = counterStart + 7
         
         self.getSubFolder1(startIndex: counterStart, endIndex: counterEnd, roomName: roomName, broadcastAddress: broadcastAddress, portNum: portNum, sPath: sPath, iSource: iSource, oldISource: oldISource, maxEnd: maxEnd)
         
         }
         else{
         self.hideHUD(isAnimated: true)
         }
         })*/
        // self.hideHUD(isAnimated: true)
    }*/
    /*
     enum Result<T> {
     case success(T)
     case error(String)
     }
     
     
     func getSubFolder(startIndex:Int, endIndex:Int, roomName:String, broadcastAddress:String, portNum:UInt16, sPath:String, iSource:String, oldISource:String, maxEnd:Int, _ complection: @escaping(Result<[Media]>)->()) {
     
     print("startIndex",startIndex,"   ","endIndex",endIndex)
     self.showHUD(progressLabel: "fetching".localized)
     var counterStart = startIndex
     var counterEnd = endIndex
     
     downLoadMedia(startIndex: startIndex, endIndex: endIndex, iSource: iSource,sPath: sPath,broadcastAddress: broadcastAddress,portNum:portNum) { (res) in
     switch res {
     case .success(let obj):
     debugPrint(obj.count)
     case .error(let strerror):
     debugPrint(strerror)
     }
     if counterEnd < maxEnd {
     //getSubFolder(startIndex: startIndex + 1, endIndex: <#T##Int#>, roomName: <#T##String#>, broadcastAddress: <#T##String#>, portNum: <#T##UInt16#>, sPath: <#T##String#>, iSource: <#T##String#>, oldISource: <#T##String#>, maxEnd: <#T##Int#>)
     }
     }
     
     
     }
     
     func downLoadMedia(startIndex:Int, endIndex:Int,iSource:String,sPath:String,broadcastAddress:String, portNum:UInt16, complection: @escaping(Result<[Media]>)->()) {
     
     let signal = Query.getSourceMenuListForPathQuery(sourceName:iSource,
     path:sPath,
     start: String(startIndex),
     end: String(endIndex))
     //  BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
     
     complection(.success([]))
     }*/
    
    
    
    
    
    //Get submenus (on folder selection)
    func callCommandGetSubMenus2(params:[String:Any]){
        //sngPlTotal
        let roomName = params["roomName"] as! String
        let iSource = params["iSource"] as! String
        let startC = params["startC"] as! String
        let endC = params["endC"] as! String
        let sPath = params["sPath"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        let startCount:Int = Int(startC)!
        let endCount: Int  = Int(endC)!
        var maxEnd:Int = ( endCount > Int(DefaultValues.maxEndCount)! ) ? endCount : Int(DefaultValues.maxEndCount)!
        print("max End \(maxEnd)")
        maxEnd = endCount
        //Tausif
        print("List of Notifcation observer \(String(describing: NotificationCenter.observationInfo()))")
        
        var counterStart = startCount
        var counterEnd = counterStart + 10
        //self.showHUD(progressLabel: "fetching".localized)
        func getFolders(startIndex:Int,endIndex:Int) {

            print("startIndex",startIndex,"   ","endIndex",endIndex)
            
            queue.asyncAfter(deadline: .now() + .milliseconds(200)) {
                let signal = Query.getSourceMenuListForPathQuery(   sourceName:iSource,
                                                                    path:sPath,
                                                                    start: String(startIndex),
                                                                    end: String(endIndex))
                BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
            }
            
            queue.asyncAfter(deadline: .now() + 0.5) {
                if (counterEnd < maxEnd), !self.isNeedToStopSongsReq {
                    getFolders(startIndex:counterStart , endIndex: counterEnd )
                    counterStart = counterEnd
                    counterEnd = counterEnd  + 10
                } else {
                    self.isNeedToStopSongsReq = false
                    self.hideHUD(isAnimated: true)
                }
            }
        }
        
        getFolders(startIndex:counterStart , endIndex: counterEnd )
        
    }
    func callCommandGetSubMenus(params:[String:Any]){
        //sngPlTotal
        let noti = NotificationCenter.default
        print("On back2 \(params)")
        noti.post(name: .UiUpdateTable, object: nil, userInfo: params)
        /*let roomName = params["roomName"] as! String
        let iSource = params["iSource"] as! String
        let startC = params["startC"] as! String
        let endC = params["endC"] as! String
        let sPath = params["sPath"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        let startCount:Int = Int(startC)!
        let endCount: Int  = Int(endC)!
        var maxEnd:Int = ( endCount > Int(DefaultValues.maxEndCount)! ) ? endCount : Int(DefaultValues.maxEndCount)!
        print("max End \(maxEnd)")
        maxEnd = endCount
        //Tausif
        print("List of Notifcation observer \(String(describing: NotificationCenter.observationInfo()))")
        
        var counterStart = startCount
        var counterEnd = counterStart + 10
        //self.showHUD(progressLabel: "fetching".localized)
        func getFolders(startIndex:Int,endIndex:Int) {
            
            print("startIndex",startIndex,"   ","endIndex",endIndex)
            
            queue.asyncAfter(deadline: .now() + .milliseconds(200)) {
                let signal = Query.getSourceMenuListForPathQuery(   sourceName:iSource,
                                                                    path:sPath,
                                                                    start: String(startIndex),
                                                                    end: String(endIndex))
                BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
            }
            
            queue.asyncAfter(deadline: .now() + 0.5) {
                if (counterEnd < maxEnd), !self.isNeedToStopSongsReq {
                    getFolders(startIndex:counterStart , endIndex: counterEnd )
                    counterStart = counterEnd
                    counterEnd = counterEnd  + 10
                } else {
                    self.isNeedToStopSongsReq = false
                    self.hideHUD(isAnimated: true)
                }
            }
        }
        
        getFolders(startIndex:counterStart , endIndex: counterEnd )*/
        
    }
    //Get current playing song
    func callCommandGetCurrentSong(params:[String:Any]){
          
        let iSource = params["iSource"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getSourcePlayingSongQuery(sourceName: iSource)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //Get first level menus on input source selection
    func callCommandGetFirstLevelMenus(params:[String:Any]){
          
        let roomName = params["roomName"] as! String
        let iSource = params["iSource"] as! String
        let oldISource = params["oldISource"] as! String
        let startC = params["startC"] as! String
        let endC = params["endC"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            guard let ampOnStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn else{return;}
            guard ampOnStatus == "0" else{return;} // evry time input source selected, amp on
            ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn = "1"
            let signal = Query.getAmpOnOffQuery(roomName:roomName, status:false) // false, make it ON, toggling
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10), execute: {
            let signal = Query.getSourceSelectedQuery(roomName:roomName, sourceName: iSource)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20), execute: {
            guard oldISource != "" else{return;}
            let signal = Query.getSourceRegisterQuery(sourceName: oldISource, status: true) // OFF old inputsource
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(30), execute: {
            let signal = Query.getSourceRegisterQuery(sourceName: iSource, status: false) // ON new inputsource
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(40), execute: {
            let signal = Query.getSourcePlayingSongQuery(sourceName: iSource)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: {
            let signal = Query.getSourceMenuListQuery(sourceName:iSource, start:startC, end:endC)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(550), execute: {
            self.startContinuousCurrentSongTimer(source:iSource, ip:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(560), execute: {
            self.startContinuousRoomAndSourceRegisterTimer(room:roomName, source:iSource, ip:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //Get input sources
    func callCommandGetInputSources(params:[String:Any]){
          
        let roomName = params["roomName"] as! String
        let oldRoomName = params["oldRoomName"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            guard oldRoomName != "" else{return;}
            let signal = Query.getRoomRegisterQuery(roomName: oldRoomName, status:true) // REGISTER OFF
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10), execute: {
            let signal = Query.getRoomActiveOnOffQuery(roomName: roomName, status:false) // ACTIVE ON
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20), execute: {
            let signal = Query.getRoomRegisterQuery(roomName: roomName, status:false) // REGISTER ON
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(30), execute: {
            let signal = Query.getRoomServiceQuery(roomName: roomName)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(40), execute: {
            self.callCommandKeepConnectionAliveWithRegister(roomName:roomName, ip: broadcastAddress, port: portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: {
            self.startContinuousRoomStatusTimer(roomName:roomName, ip:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //Get room automatically
    func callCommandGetRooms(params:[String:Any]){
          
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getAllFriendDeviceIDQuery(ip: broadcastAddress, port: portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10), execute: {
            let signal = Query.getRoomsQuery()
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            guard ModelHome.availableRooms.count > 0 else {return}
            var params = [String:Any]()
            if let room = ModelHome.availableRooms[0].roomName{
                params.updateValue(room, forKey: "roomName")
            }
            params.updateValue(broadcastAddress, forKey: "broadcastAddress")
            params.updateValue(portNum, forKey: "portNum")
            self.callCommandGetNetworkIPs(params:params)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600), execute: {
            guard !self.isAlreadyGotXMLFromNetStream else{return;} // To avoid multiple calls
            
            self.isAlreadyGotXMLFromNetStream = true
            self.callCommandKeepConnectionAlive(ip: broadcastAddress, port: portNum)
            
            guard ModelHome.availableRooms.count > 0 else {
                self.onGetRoomsFailed(failureMsg: "autoDiscoveryFailed".localized)
                return;
            }
            guard let roomIP = ModelHome.availableRooms[0].roomSetting?.IP else{
                self.onGetRoomsFailed(failureMsg: "invalidIPAddress".localized)
                return;
            }
            self.getXMLData(roomIP:roomIP)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //Get xml data form Netstream system
    func getXMLData(roomIP:String){
          
        APIManager.shared.getData(urlStr: "http://\(roomIP)/gui.xml", completion: { data,status in
            guard status, let data = data else{
                self.onGetRoomsFailed(failureMsg: "xmlDownloadFailed".localized)
                return;
            }
            
            //@@@*
            //            guard let xmlPath = Bundle.main.url(forResource: "gui", withExtension: "xml") else{
            //                self.onGetRoomsFailed(failureMsg: "Invalid path for xml file")
            //                return;
            //            }
            //            guard let xmlData = try? Data(contentsOf: xmlPath) else{
            //                self.onGetRoomsFailed(failureMsg: "Unable to get data from url")
            //                return;
            //            }
            //            guard let xmlStr = String(bytes:xmlData, encoding:.utf8)?.replaceAnd() else{
            //@@@*
            
            guard let xmlStr = String(bytes:data, encoding:.utf8) else{
                self.onGetRoomsFailed(failureMsg: "dataToXmlConversionFailed".localized)
                return;
            }
            let parser = ParseXMLFileData(xml: xmlStr)
            let jsonStr = parser.parseXML()
            print(jsonStr)
            
            //ModelHome.addLog(str: "Netstream system XML response converted to JSON: \(jsonStr)") //@@@
            
            guard let jsonData = jsonStr.data(using: .utf8, allowLossyConversion: true) else{
                self.onGetRoomsFailed(failureMsg: "strToDataConversionFailed".localized)
                return;
            }
            //This is optional to check json string is valid or not //@@@
            guard let _ = try? JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? [Dictionary<String,Any>] else{
                self.onGetRoomsFailed(failureMsg: "xmlToJsonConversionFailed".localized)
                return;
            }
            let jsonDecoder = JSONDecoder()
            guard let xmlFileData = try? jsonDecoder.decode(XMLFileData.self, from: jsonData) else{
                self.onGetRoomsFailed(failureMsg: "xmlMappingToModelFailed".localized)
                return;
            }
            ModelHome.availableRooms = []
            guard let arrRoom = xmlFileData.gui?.rooms?.room, arrRoom.count > 0 else{
                self.onGetRoomsFailed(failureMsg: "noRoomsFound".localized)
                return;
            }
            // Add rooms
            for room in arrRoom{
                print("room.screens?.screen \(room.screens?.screen)")
                guard let displayRoomName = room.id,
                    let arrScreen = room.screens?.screen, arrScreen.count > 0 else{continue;}
                var dictRoom = [String:Any]()
                dictRoom.updateValue(displayRoomName, forKey: "displayRoomName")
                dictRoom.updateValue(false, forKey: "isSelected")
                dictRoom.updateValue("", forKey: "selectedPath")
                var arrSources = [AvailableInputSourcesForRoom]()
                var arrFavourites = [AvailableFavouritesForRoom]()
                var roomName = ""
                for screen in arrScreen{
                    guard let serviceName = screen.serviceName, serviceName.lowercased().contains(displayRoomName.lowercased()), serviceName.lowercased().contains("player") else{
                        
                        //if let cameras = screen.cameras
                        
                        if let favourites = screen.favourite{
                            for fav in favourites{
                                var dictFavourite = [String:Any]()
                                dictFavourite.updateValue(fav.id ?? "", forKey: "id")
                                dictFavourite.updateValue(fav.macro ?? "", forKey: "macro")
                                dictFavourite.updateValue(fav.display ?? "", forKey: "display")
                                dictFavourite.updateValue(false, forKey: "isSelected")
                                dictFavourite.updateValue(roomName, forKey: "roomName")
                                let availFavourite = AvailableFavouritesForRoom.init(dictionary: dictFavourite)
                                arrFavourites.append(availFavourite!)
                            }
                        }
                        
                        
                        guard let screenType = screen.type, screenType.lowercased() == "sources" else{continue;}
                        guard let arrMenu = screen.menu, arrMenu.count > 0 else{continue;}
                        for menu in arrMenu{
                            guard let arrItem = menu.item, arrItem.count > 0 else{continue;}
                            // Set for off inputsource for first position
                            var dictSource = [String:Any]()
                            dictSource.updateValue("Off", forKey: "displaySourceName")
                            dictSource.updateValue(" ", forKey: "sourceName")
                            dictSource.updateValue(false, forKey: "isSelected")
                            dictSource.updateValue(roomName, forKey: "roomName")
                            let availInputSource = AvailableInputSourcesForRoom.init(dictionary: dictSource)
                            arrSources.append(availInputSource!)
                            //Add input sources
                            for item in arrItem{
                                guard let serviceName = item.serviceName else{continue;}
                                var dictSource = [String:Any]()
                                dictSource.updateValue(serviceName, forKey: "displaySourceName")
                                dictSource.updateValue(serviceName, forKey: "sourceName")
                                dictSource.updateValue(false, forKey: "isSelected")
                                dictSource.updateValue(roomName, forKey: "roomName")
                                let availInputSource = AvailableInputSourcesForRoom.init(dictionary: dictSource)
                                arrSources.append(availInputSource!)
                            }
                        }
                        continue;
                    }
                    roomName = serviceName
                    dictRoom.updateValue(roomName, forKey: "roomName")
                    if let enabled = screen.enabled{
                        dictRoom.updateValue(enabled, forKey: "enabled")
                    }
                }
                dictRoom.updateValue(arrFavourites, forKey: "favourites")
                dictRoom.updateValue(arrSources, forKey: "inputSources") // initialize with empty input sources
                let availRoom = AvailableRooms.init(dictionary: dictRoom)
                ModelHome.availableRooms.append(availRoom!)
            }
            if ModelHome.availableRooms.count > 0{
                self.connectedToIPAddress = roomIP
                ModelHome.isConnectedToNetStream = true
                
                //Update that, very first broadcast message has recieved
                DispatchQueue.main.async {
                    let _ = PostNotification.init(status: true, message: "Success!", socketType: .broadcast)
                    BroadcastSocket.isReceivingForFirstTime = true
                }
            }
            let _ = PostNotification.init(selectedType:.rooms) // update room list
        })
    }
    
    //Get rooms manually
    func callCommandGetRoomsManually(params:[String:Any]){
          
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        let manualAddress = params["manualAddress"] as! String
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            guard !self.isAlreadyGotXMLFromNetStream else{return;} // To avoid multiple calls
            
            self.isAlreadyGotXMLFromNetStream = true
            self.callCommandKeepConnectionAlive(ip: broadcastAddress, port: portNum)
            self.getXMLData(roomIP:manualAddress)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    
    //MARK: Audio/Media Setting control signals
    
    //Get Control setting for room
    func callCommandGetRoomCurrentSetting(userInfo:[String:Any], params:[String:Any]){
          
        let roomName = params["roomName"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        let signal = Query.getRoomCurrentSetting(roomName: roomName)
        BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
    }
    
    //Set Control mute/unmute
    func callCommandSetMute(userInfo:[String:Any], params:[String:Any]){
          
        let roomName = params["roomName"] as! String
        let status = userInfo["status"] as! Bool
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getVolumeMuteOnOffQuery(roomName:roomName, status:status)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //Set Control Amplifier (A/V)
    func callCommandSetAMP(userInfo:[String:Any], params:[String:Any]){
          
        let roomName = params["roomName"] as! String
        let status = userInfo["status"] as! Bool
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getAmpOnOffQuery(roomName:roomName, status:status)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //Control Presets (Loudness)
    func callCommandSetLoudnessPreset(userInfo:[String:Any], params:[String:Any]){
          
        let roomName = params["roomName"] as! String
        let value = userInfo["value"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getLoudnessQuery(roomName: roomName, value: value)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //Set Control Equalizer
    func callCommandSetEqualizer(userInfo:[String:Any], params:[String:Any]){
          
        let value = userInfo["value"] as! String
        let settingControl = userInfo["settingControl"] as! String
        let roomName = params["roomName"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        let signal = Query.getSettingControlSetQuery(roomName: roomName, settingControl: settingControl, value: value)
        BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
    }
    
    //Set Control volume
    func callCommandSetVolume(userInfo:[String:Any], params:[String:Any]){
          
        let value = userInfo["value"] as! String
        let settingControl = userInfo["settingControl"] as! String
        let roomName = params["roomName"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        let signal = Query.getSettingControlSetQuery(roomName: roomName, settingControl: settingControl, value: value)
        BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
    }
    
    //MARK: Audio/Media Player control signals
    
    //next song
    func callCommandNextSong(params:[String:Any]){
          
        let iSource = params["iSource"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getNextSongSelectedQuery(sourceName:iSource)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //previous song
    func callCommandPreviousSong(params:[String:Any]){
          
        let iSource = params["iSource"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getPreviousSongSelectedQuery(sourceName:iSource)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //play current(now) song
    func callCommandPlayNowSong(params:[String:Any]){
          
        //let roomName = params["roomName"] as! String
        let iSource = params["iSource"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            //let signal = Query.getPlaySongSelectedQuery(sourceName:iSource)
            //BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
            let signal0 = Query.getPlaySongSelectedQuery(sourceName:iSource) //iSource, roomName
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //pause current(now) song
    func callCommandPauseNowSong(params:[String:Any]){
          
        //let roomName = params["roomName"] as! String
        let iSource = params["iSource"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            //let signal = Query.getPauseSongSelectedQuery(sourceName:iSource)
            //BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
            let signal0 = Query.getPauseSongSelectedQuery(sourceName:iSource)//iSource ,roomName
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //stop current(now) song
    func callCommandStopNowSong(params:[String:Any]){
          
        let iSource = params["iSource"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getStopSongSelectedQuery(sourceName:iSource)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //Shuffle/toggle
    func callCommandShuffleNowSong(userInfo:[String:Any], params:[String:Any]){
          
        //let roomName = params["roomName"] as! String
        let iSource = params["iSource"] as! String
        let status = userInfo["status"] as! Bool
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            //let signal = Query.getShuffleSongSelectedQuery(sourceName:iSource, status: status)
            //BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
            let signal0 = Query.getShuffleSongSelectedQuery(sourceName:iSource, status: status) //iSource ,roomName
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal0, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //MARK: MultiRooms control Signals
    
    //Create multiroom
    func callCommandCreateMultiRoom(userInfo:[String:Any], params:[String:Any]){
          
        /*
         let roomName = params["roomName"] as! String
         let broadcastAddress = params["broadcastAddress"] as! String
         let portNum = params["portNum"] as! UInt16
         
         self.showHUD(progressLabel: "fetching".localized)
         DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
         let signal = Query.getMultiRoomCreateQuery(roomName: roomName)
         BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
         })
         DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
         self.hideHUD(isAnimated: true)
         })
         */
    }
    
    //Cancel multiroom
    func callCommandCancelMultiRoom(userInfo:[String:Any], params:[String:Any]){
          
        //let roomName = params["roomName"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        let multiRoom = userInfo["multiRoom"] as! String
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getMultiRoomCancelQuery(sessionName: multiRoom)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //Join multiroom
    func callCommandJoinMultiRoom(userInfo:[String:Any], params:[String:Any]){
          
        let roomName = params["roomName"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        let multiRoom = userInfo["multiRoom"] as! String
        let iSource = params["iSource"] as! String
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getMultiRoomCreateQuery(sessionName: multiRoom)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10), execute: {
            let signal = Query.getMultiRoomActiveOnOffQuery(sessionName: multiRoom, status:false)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20), execute: {
            let signal = Query.getMultiRoomMuteOnOffQuery(sessionName: multiRoom, status:true)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(30), execute: {
            let signal = Query.getMultiRoomSetDefaultVolumeQuery(sessionName: multiRoom)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(40), execute: {
            let signal = Query.getMultiRoomSelectSourceQuery(sessionName: multiRoom, source:iSource)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: {
            let signal = Query.getMultiRoomJoinQuery(roomName: roomName, sessionName: multiRoom)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(550), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //Leave multiroom
    func callCommandLeaveMultiRoom(userInfo:[String:Any], params:[String:Any]){
          
        let roomName = params["roomName"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        self.showHUD(progressLabel: "fetching".localized)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            let signal = Query.getMultiRoomLeaveQuery(roomName: roomName)
            BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
    
    //Set Multiroom volume
    func callCommandSetMultiRoomVolume(userInfo:[String:Any], params:[String:Any]){
          
        let value = userInfo["value"] as! String
        let multiRoom = userInfo["multiRoom"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        let signal = Query.getMultiRoomSetVolumeQuery(sessionName: multiRoom, value: value)
        BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
    }
    
    //Set Multiroom Mute On/Off
    func callCommandSetMultiRoomMute(userInfo:[String:Any], params:[String:Any]){
          
        let status = userInfo["status"] as! Bool
        let multiRoom = userInfo["multiRoom"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        let signal = Query.getMultiRoomMuteOnOffQuery(sessionName: multiRoom, status: status)
        BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
    }
    
    //Set Multiroom AMP On/Off
    func callCommandSetMultiRoomAMP(userInfo:[String:Any], params:[String:Any]){
          
        let status = userInfo["status"] as! Bool
        let multiRoom = userInfo["multiRoom"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        let signal = Query.getMultiRoomAMPOnOffQuery(sessionName: multiRoom, status: status)
        BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
    }
    
    //Set Favourite
    func callCommandSetFavourite(userInfo:[String:Any], params:[String:Any]){
          
        let roomName = params["roomName"] as! String
        let favourite = userInfo["favourite"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        let signal = Query.getFavouriteQuery(roomName: roomName, favourite: favourite)
        BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
    }
}


