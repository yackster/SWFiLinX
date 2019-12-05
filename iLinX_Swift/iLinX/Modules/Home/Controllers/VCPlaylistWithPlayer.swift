//
//  VCPlaylistWithPlayer.swift
//  iLinX
//
//  Created by Vikas Ninawe on 30/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit
import SDWebImage
import MediaPlayer
import Queuer
import MBProgressHUD
class VCPlaylistWithPlayer: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var navigationCon: UINavigationBar!
    
    @IBOutlet weak var searchBar: UISearchBar!
    // var arrIndexSection: NSArray = ["A","B","C","D", "E", "F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    @IBOutlet weak var searchView: UIView!
    // MARK:-  Outlets
    let searchController = UISearchController(searchResultsController: nil)
    
    var hud: MBProgressHUD = MBProgressHUD()
    @IBOutlet weak var cellSongListTableView: UITableView!
    @IBOutlet weak var vwMediaCollection: UIView!
    @IBOutlet weak var vwMediaPresets: UIView!
    @IBOutlet weak var btnRearrange: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var collectionVwMediaPresets: UICollectionView!
    @IBOutlet weak var vwSongs: UIView!
    @IBOutlet weak var collectionVwSongs: UICollectionView!
    @IBOutlet weak var vwPlayingAlbum: UIView!
    @IBOutlet weak var imgVwPlayingAlbum: UIImageView!
    @IBOutlet weak var lblPlayingAlbumName: UILabel!
    @IBOutlet weak var lblPlayingAlbumDetails: UILabel!
    @IBOutlet weak var lblPlayingAlbumMoreDetails: UILabel!
    @IBOutlet weak var vwMediaPlayer: UIView!
    @IBOutlet weak var sliderOfMediaPlayer: UISlider!
    @IBOutlet weak var lblMediaStartTime: UILabel!
    @IBOutlet weak var lblMediaEndTime: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var vwMediaPlayBtnBackground: UIView!
    @IBOutlet weak var btnPlayPauseReload: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnShuffle: UIButton!
    @IBOutlet weak var vwVolumeControl: UIView!
    @IBOutlet weak var btnAVOnOff: UIButton!
    @IBOutlet weak var btnMuteOnOff: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    var filteredSong: [MenuResp] = []
    var isSearch = false
    var isSearchTxt = false
    var isReset = false
    @IBOutlet weak var sliderVolume: UISlider!{
        didSet{ sliderVolume.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2)) }
    }
    
    // MARK:- Variables and Flags
    var isMediaArrangedWithList = false
    var arrMediaPresets = [MediaPresets]()
    var arrMedias = [MenuResp]()//[Media]()
    var tempCount = 0
    var timerBuffer : Timer?
    var songItem: [MenuResp] = []
    lazy var items: [MenuResp] = []
    lazy var queue = Queuer(name: "MyCustomQueue")
    static var totalSong: Int = 0
    var maxEnd: Int = 0
    /*  var items: [MenuResp] = [] {
     didSet {
     DispatchQueue.main.async {
     if self.items.count > 0, self.tempCount != self.items.count {
     self.tempCount = self.items.count
     self.cellSongListTableView.reloadData()
     self.toGetAllSongsCheckTimer()
     }
     }
     }
     }*/
    
    var count = 0
    
    //var searchItems: [[String: [MenuResp]]] = []
    var arrMediasDictionary = [String: [MenuResp]]()
    var arrMediasTitles = [String]()
    var arrPresets = [Presets]()
    var arrSettingControls = Query.arrSettingControls
    var currentPlayingSong:CurrentPlayingSongs?
    
    let songsQueue = DispatchQueue.init(label: "com.iLinX.gettingSongs", qos: .unspecified)
    var tempPath = ""
    var endCount = "" {
        didSet {
            debugPrint("End Count has changed to-", endCount)
            
        }
    }
    var timerToGetSongs: Timer?
    weak var homeVC: VCHome?
    // lazy   var searchBars:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
    // MARK:- ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //hud = MBProgressHUD.showAdded(to: cellSongListTableView, animated: true)
        
        //  hud.show(animated: true)
        self.collectionVwMediaPresets.tag = 11
        self.collectionVwMediaPresets.delegate = self
        self.collectionVwMediaPresets.dataSource = self
        
        self.collectionVwSongs.tag = 12
        self.collectionVwSongs.delegate = self
        self.collectionVwSongs.dataSource = self
        self.collectionVwSongs.isHidden = false
        
        self.imgVwPlayingAlbum.image = #imageLiteral(resourceName: "album")
        self.lblPlayingAlbumName.text = "unknown".localized
        self.lblPlayingAlbumDetails.text = "unknown".localized
        self.lblPlayingAlbumMoreDetails.text = "unknown".localized
        
        // add drop shadow with corner radius
        self.vwSongs.addShadowAllSide()
        self.vwVolumeControl.addShadowAllSide()
        self.vwMediaPlayer.addShadowAllSide()
        
        //UI setup
        self.vwMediaCollection.backgroundColor = .iLinXBGColor
        
        let notif = NotificationCenter.default
        notif.addObserver(self, selector: #selector(self.updateUI(_:)), name: .uiUpdateContainerPlaylistWithPlayer, object: nil)
        notif.addObserver(self, selector: #selector(self.updateSongList(_:)), name: .uiUpdateSongList, object: nil)
        notif.addObserver(self, selector: #selector(self.updateAVPlayer(_:)), name: .uiUpdateAVPlayer, object: nil)
        notif.addObserver(self, selector: #selector(self.showAlert(_:)), name: .showErrorPopUp, object: nil)
        notif.addObserver(self, selector: #selector(self.updateSetting(_:)), name: .uiUpdateSetting, object: nil)
        notif.addObserver(self, selector: #selector(self.callCommandGetSongItem(_:)), name: .UiUpdateTable, object: nil)
        notif.addObserver(self, selector: #selector(self.resumePauseQueueLoading(_:)), name: .resumePauseQueue, object: nil)
        //set action target to volume slider
        self.sliderVolume.addTarget(self, action: #selector(self.onVolumeSliderChanged(_:_:)), for: .valueChanged)
        
        self.searchBar.delegate = self
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
     
        self.initialization()
       // tempMuteSettingTesting()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.cellSongListTableView.dataSource = self
        self.cellSongListTableView.delegate = self
        self.btnPlayPauseReload.accessibilityIdentifier = AVPlayerStatus.idle.rawValue
        self.btnStop.accessibilityIdentifier = AVPlayerStatus.idle.rawValue
        self.btnNext.accessibilityIdentifier = AVPlayerStatus.idle.rawValue
        self.btnPrevious.accessibilityIdentifier = AVPlayerStatus.idle.rawValue
        self.btnShuffle.accessibilityIdentifier = AVPlayerStatus.idle.rawValue
        self.updateBackButtonUI(path: SelectedItemDetails.selectedPath)
        cellSongListTableView.register(UINib(nibName: "songList", bundle: nil), forCellReuseIdentifier: "CellSongListTableViewCell")
        self.searchBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
     //   self.searchBar.searchTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        reloadTableData()
        self.cellSongListTableView.tintColor = .iLinXBlueColor
        
        self.setValues()
    }
    
    override func viewWillLayoutSubviews() {
        self.vwMediaPlayBtnBackground.layer.cornerRadius = self.vwMediaPlayBtnBackground.frame.width*0.5
        self.vwMediaPlayBtnBackground.clipsToBounds = true
        self.sliderOfMediaPlayer.setThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
        self.sliderOfMediaPlayer.isUserInteractionEnabled = true
        self.sliderVolume.setThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notif = NotificationCenter.default
        notif.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Volume changes on slider moves
    @objc func onVolumeSliderChanged(_ sender: UISlider, _ event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                var data : [String:Any] = [:]
                data["isPause"] = true
                let notif = NotificationCenter.default
                notif.post(name: .pauseResumeRoomStatusTimer, object: nil, userInfo: data)
            case .moved:
                let finalValue = Int(Float(sender.value).rounded())
                guard finalValue%5 == 0 else{ return; } // call on every 5th step
                self.updateVolumeSliderValue(value: String(sender.value), callCommand: true)
            case .ended:
                self.updateVolumeSliderValue(value: String(sender.value), callCommand: true)
                
                var data : [String:Any] = [:]
                data["isPause"] = false
                let notif = NotificationCenter.default
                notif.post(name: .pauseResumeRoomStatusTimer, object: nil, userInfo: data)
            default:
                break;
            }
        }
    }
    
    // MARK:- Update UI on notification received for container
    @objc func updateUI(_ notification: NSNotification) {
        //
        self.btnPlayPauseReload.accessibilityIdentifier = AVPlayerStatus.idle.rawValue
        self.btnStop.accessibilityIdentifier = AVPlayerStatus.idle.rawValue
        self.btnNext.accessibilityIdentifier = AVPlayerStatus.idle.rawValue
        self.btnPrevious.accessibilityIdentifier = AVPlayerStatus.idle.rawValue
        self.btnShuffle.accessibilityIdentifier = AVPlayerStatus.idle.rawValue
        self.updateBackButtonUI(path: SelectedItemDetails.selectedPath)
        reloadTableData()
    }
    
    //MARK: Update setting (Value for all the controls)
    @objc func updateSetting(_ notification: NSNotification) {
        //
        self.setValues()
    }
    
    //MARK: Update Items list on notification received
    @objc func updateSongList(_ notification: NSNotification){
        reloadTableData()
    }
    @objc func updateSongList1() {
        //
        let notif = NotificationCenter.default
        notif.post(name: .socketCallFromContainer, object: nil, userInfo: [:])
    }
    //MARK: Update Audio player on notification received
    @objc func updateAVPlayer(_ notification: NSNotification){ //  AVPlayer ui udpate
        let info = notification.userInfo
        //
        if let room = info?["room"] as? String, let source = info?["source"] as? String {
            let arrTmp = ModelHome.currentPlayingSongs.filter{$0.roomName == room && $0.sourceName == source} // check if roomnames and sourcenames are equa
            guard arrTmp.count > 0 else {
                // Call only if input soruce selected as " " ie. Off
                if SelectedItemDetails.inputSourceName == " "{
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
                        self.updateAVPlayerUI(data: CurrentPlayingSongs(dictionary: [:])!)
                    })
                }
                return;
            }
            self.updateAVPlayerUI(data: arrTmp[0])
        }
    }
    
    //MARK: Show alert pop_up on notification received
    @objc func showAlert(_ notification: NSNotification){ //  show alert
        //
        guard (self.presentedViewController == nil) else { return; } // don't show if alert is already presented
        guard let errorMsg = notification.userInfo?["error"] as? String  else{return;}
        self.presentAlertWithTitle(title: "ilinx".localized, message: errorMsg, options: "ok".localized) { (option) in // options: "ok", "cancel"
            switch(option) {
            case 0: break; ////print("ok".localized)
            //case 1: break; ////print("cancel".localized)
            default: break
            }
        }
    }
    private func showNoSongAlert(msg:String){
        
        self.presentAlertWithTitle(title:"ilinx".localized, message:msg, options:"ok".localized) { (option) in
            switch(option){
            case 0: break; //print("ok".localized)
            default: break;
            }
        }
    }
    @IBAction func onAVOnOff(_ sender: UIButton) {
        //
        guard let ampOnStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn else{return}
        let newAmpOnStatus = (ampOnStatus == "1") ? "0" : "1"
        ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn = newAmpOnStatus
        self.btnAVOnOff.setImage((newAmpOnStatus == "1") ? #imageLiteral(resourceName: "av_on") : #imageLiteral(resourceName: "av_off"), for: .normal)
        
        // Audio ON/OFF message on touchlinx
        SelectedItemDetails.elementType = .amp
        var data : [String:Any] = [:]
        data["status"] = newAmpOnStatus == "0" ? true : false
        data["controlState"] = true
        let notif = NotificationCenter.default
        notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    @IBAction func onInfo(_ sender: UIButton) {
        //
        guard let currentPlayingSongData = self.currentPlayingSong else{return;}
        
        let vcSongDetails = self.storyboard!.instantiateViewController(withIdentifier: "VCSongDetails") as! VCSongDetails
        vcSongDetails.modalPresentationStyle = .overCurrentContext
        vcSongDetails.modalTransitionStyle = .crossDissolve
        vcSongDetails.currentPlayingSong = currentPlayingSongData
        let popOver = vcSongDetails.popoverPresentationController
        popOver?.permittedArrowDirections = .any
        popOver?.delegate = self
        popOver?.sourceView = sender
        present(vcSongDetails, animated: false, completion: nil)
    }
    func tempMuteSettingTesting() -> Void {
        guard let muteStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.mute else {return}
        let newMuteStatus = (muteStatus == "1") ? "0" : "1"
        ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.mute = newMuteStatus
        self.btnMuteOnOff.setImage((newMuteStatus == "1") ? #imageLiteral(resourceName: "volume_off") : #imageLiteral(resourceName: "volume_on"), for: .normal)
        
        // Volume MUTE ON/OFF message on touchlinx
        SelectedItemDetails.elementType = .mute
        var data : [String:Any] = [:]
        data["status"] = (newMuteStatus == "0") ? true : false
        data["controlState"] = true
        let notif = NotificationCenter.default
        notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    @IBAction func onMuteOnOff(_ sender: UIButton) {
        //
        guard let muteStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.mute else {return}
        let newMuteStatus = (muteStatus == "1") ? "0" : "1"
        ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.mute = newMuteStatus
        self.btnMuteOnOff.setImage((newMuteStatus == "1") ? #imageLiteral(resourceName: "volume_off") : #imageLiteral(resourceName: "volume_on"), for: .normal)
        
        // Volume MUTE ON/OFF message on touchlinx
        SelectedItemDetails.elementType = .mute
        var data : [String:Any] = [:]
        data["status"] = (newMuteStatus == "0") ? true : false
        data["controlState"] = true
        let notif = NotificationCenter.default
        notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    @IBAction func onRearrange(_ sender: UIButton) {
        //
        guard self.arrMedias.count > 0 else { return; }
        self.isMediaArrangedWithList = self.isMediaArrangedWithList ? false : true
        sender.setImage((self.isMediaArrangedWithList ? #imageLiteral(resourceName: "menu")  : #imageLiteral(resourceName: "listmenu") ), for: .normal)
        self.collectionVwSongs.reloadData()
        if self.isMediaArrangedWithList{
            //for item in arrMedias {
            //print("song list is \(item.display)")
            //}
            
            reloadTableData()
            //print("song list grouped is \(items)")
            self.cellSongListTableView.dataSource = self
            self.cellSongListTableView.delegate = self
            self.cellSongListTableView.isHidden = true
            
            self.collectionVwSongs.isHidden = false
        }else{
            reloadTableData()
            self.cellSongListTableView.isHidden = true
            self.collectionVwSongs.isHidden = false
        }
    }
    
    func loadSongsDividedByTitle1() {
        //
        songsQueue.async {
            self.arrMediasTitles.removeAll()
            self.addDataFromItem(arr: self.arrMedias)
        }
    }
    
    func toGetAllSongsCheckTimer() {
        //
        if self.timerToGetSongs != nil {
            self.timerToGetSongs?.invalidate()
        }
        self.timerToGetSongs = Timer.scheduledTimer(withTimeInterval: 20, repeats: false) {_ in
            
            if (Int((Double(SelectedItemDetails.end) ?? 10) * 0.5) * 3  > self.items.count) {
                debugPrint("TO Get Allsong Timer called with point \(self.items.count - 1)- \(self.endCount)")
                SelectedItemDetails.start = "\(self.items.count - 1)"
                SelectedItemDetails.selectedPath = self.tempPath
                ModelHome.availableRooms[SelectedItemDetails.roomIndex].selectedPath = SelectedItemDetails.selectedPath
                SelectedItemDetails.end = self.endCount
                SelectedItemDetails.selectedSongPath = ""
                SelectedItemDetails.elementType = .item
                
                let notif = NotificationCenter.default
                notif.post(name: .socketCallFromContainer, object: nil, userInfo: [:])
            }
        }
    }
    
    func   loadSongsDividedByTitle() -> [MenuResp] {
        
        var groupedSongs : [MenuResp] = []
        for mediaItem in self.arrMedias {
            if !groupedSongs.contains(mediaItem) {
                groupedSongs.append(mediaItem)
            }
        }
        return groupedSongs
    }
    func filterSearchSong(for SearchTxt:String){
        //
        filteredSong = items.filter { songsSearched in
            return (songsSearched.display?.lowercased().contains(SearchTxt.lowercased()))!
        }
        
    }
    func addDataFromItem(arr: [MenuResp]) {
        var itemCount = self.items.count - 1
        if itemCount < 0 {
            itemCount = 0
        }
        if self.items.count < arr.count {
            for index in itemCount..<arr.count {
                if index < arr.count, !self.items.contains(arr[index]) {
                    self.items.append(arr[index])
                    
                }
            }
        } else {
            for mediaItem in arr {
                if !self.items.contains(mediaItem) {
                    self.items.append(mediaItem)
                }
            }
        }
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        homeVC?.isNeedToStopSongsReq = true
        cancelQueue()
        items.removeAll()
        count = 0
        tempPath = ""
        endCount = "10"
        let arrPath = SelectedItemDetails.selectedPath.split(separator: ">").dropLast()
        SelectedItemDetails.selectedPath = (arrPath.count > 0) ? arrPath.joined(separator: ">") : ""
        SelectedItemDetails.selectedSongPath = ""
        SelectedItemDetails.start = DefaultValues.startcount
        SelectedItemDetails.end = DefaultValues.endCount
        SelectedItemDetails.elementType = .none // reset element type on back
        self.updateBackButtonUI(path: SelectedItemDetails.selectedPath)
        let notif = NotificationCenter.default
        notif.post(name: .socketCallFromContainer, object: nil, userInfo: [:])
        guard arrPath.isEmpty else {return}
        reloadTableData()
    }
    
    //MARK: Set values for controls
    func setValues(){
        //
        guard (SelectedItemDetails.roomIndex > -1) else { return; }
        
        //mute
        if let muteStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.mute{
            self.btnMuteOnOff.setImage((muteStatus == "1") ? #imageLiteral(resourceName: "volume_off") : #imageLiteral(resourceName: "volume_on"), for: .normal)
        }
        
        //ampOn / AV
        if let ampOnStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn{
            self.btnAVOnOff.setImage((ampOnStatus == "1") ? #imageLiteral(resourceName: "av_on") : #imageLiteral(resourceName: "av_off"), for: .normal)
        }
        
        //Volume
        let volume = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.vol
        self.updateVolumeSliderValue(value: volume, callCommand: false)
    }
    
    //MARK: Update volume on slider changed (Actual call)
    private func updateVolumeSliderValue(value:String?, callCommand:Bool){
        //
        guard let volValue = value else { return; }
        self.sliderVolume.setValue(Float(volValue)!.rounded(), animated: true)
        
        guard callCommand else { return; }
        let finalValue = Int(Float(volValue)!.rounded())
        SelectedItemDetails.elementType = .volume
        var data : [String:Any] = [:]
        data["value"] = String(finalValue)
        data["controlState"] = true
        data["settingControl"] = self.arrSettingControls.last // last index value for volume
        NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    private func changeColorOfSubString(str:String, subStr:String) -> NSMutableAttributedString{
        //
        let range = (str as NSString).range(of: subStr)
        let attributedStr = NSMutableAttributedString.init(string: str)
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.iLinXGrayColor , range: range)
        return attributedStr;
    }
    
    //MARK: Update audio player and thumbnail
    func updateAVPlayerUI(data:CurrentPlayingSongs){
        //
        
        self.currentPlayingSong = data
        
        if let url = data.songStatus?.artwork, url.count > 0{ // Load song thumbnail
            self.imgVwPlayingAlbum.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "netstream_default") ,  options: .refreshCached)
        }else{
            self.imgVwPlayingAlbum.image = #imageLiteral(resourceName: "album")
        }
        
        let song = "song".localized
        let album = "album".localized
        let next = "next".localized
        let unspecified = "unspecified".localized
        
        if let songName = data.songStatus?.song, songName.count > 0{
            self.lblPlayingAlbumName.attributedText = self.changeColorOfSubString(str:"\(song) \(songName)", subStr:song)
        }else{
            self.lblPlayingAlbumName.attributedText = self.changeColorOfSubString(str:"\(song) \(unspecified)", subStr:song)
        }
        if let albumName = data.songStatus?.album, albumName.count > 0{
            self.lblPlayingAlbumDetails.attributedText = self.changeColorOfSubString(str:"\(album) \(albumName)", subStr:album)
        }else{
            self.lblPlayingAlbumDetails.attributedText = self.changeColorOfSubString(str:"\(album) \(unspecified)", subStr:album)
        }
        if let nextSongName = data.songStatus?.next, nextSongName.count > 0{
            self.lblPlayingAlbumMoreDetails.attributedText = self.changeColorOfSubString(str:"\(next) \(nextSongName)", subStr:next)
        }else{
            self.lblPlayingAlbumMoreDetails.attributedText = self.changeColorOfSubString(str:"\(next) \(unspecified)", subStr:next)
        }
        
        if let controlState = data.songStatus?.controlState, controlState.count > 0{
            guard let state = AVPlayerStatus(rawValue: controlState.lowercased()) else{return}
            switch state{
            case .play: // if state play, then you can pause or stop
                self.btnPlayPauseReload.setImage(#imageLiteral(resourceName: "pause_blue_button"), for: .normal)
                self.btnStop.setImage(#imageLiteral(resourceName: "stop_blue_button"), for: .normal)
                self.btnPlayPauseReload.accessibilityIdentifier = AVPlayerStatus.pause.rawValue//"pause"
                self.btnStop.accessibilityIdentifier = AVPlayerStatus.stop.rawValue //"stop"
            case .pause: // if state pause, then you can play or stop
                self.btnPlayPauseReload.setImage(#imageLiteral(resourceName: "play_blue_button"), for: .normal)
                self.btnStop.setImage(#imageLiteral(resourceName: "stop_blue_button"), for: .normal)
                self.btnPlayPauseReload.accessibilityIdentifier = AVPlayerStatus.play.rawValue //"play"
                self.btnStop.accessibilityIdentifier = AVPlayerStatus.stop.rawValue //"stop"
            case .stop: // if state stop, then you can't play or pause or stop
                self.btnPlayPauseReload.setImage(#imageLiteral(resourceName: "play_gray_button"), for: .normal)
                self.btnStop.setImage(#imageLiteral(resourceName: "stop_gray_button"), for: .normal)
                self.btnPlayPauseReload.accessibilityIdentifier = AVPlayerStatus.idle.rawValue //"idle"
                self.btnStop.accessibilityIdentifier = AVPlayerStatus.idle.rawValue //"idle"
            case .idle, .next, .prev, .reload: // default idle state
                self.btnPlayPauseReload.setImage(#imageLiteral(resourceName: "play_gray_button"), for: .normal)
                self.btnStop.setImage(#imageLiteral(resourceName: "stop_gray_button"), for: .normal)
                self.btnPlayPauseReload.accessibilityIdentifier = AVPlayerStatus.idle.rawValue //"idle"
                self.btnStop.accessibilityIdentifier = AVPlayerStatus.idle.rawValue //"idle"
            }
        }else{
            self.btnPlayPauseReload.setImage(#imageLiteral(resourceName: "play_gray_button"), for: .normal)
            self.btnStop.setImage(#imageLiteral(resourceName: "stop_gray_button"), for: .normal)
            self.btnPlayPauseReload.accessibilityIdentifier = AVPlayerStatus.idle.rawValue //"idle"
            self.btnStop.accessibilityIdentifier = AVPlayerStatus.idle.rawValue //"idle"
        }
        
        if let sngPlIndex = data.songStatus?.sngPlIndex, sngPlIndex == "0"{ // iPod is locked
            self.btnPlayPauseReload.setImage(#imageLiteral(resourceName: "play_gray_button"), for: .normal)
            self.btnStop.setImage(#imageLiteral(resourceName: "stop_gray_button"), for: .normal)
            self.btnPlayPauseReload.accessibilityIdentifier = AVPlayerStatus.idle.rawValue //"idle"
            self.btnStop.accessibilityIdentifier = AVPlayerStatus.idle.rawValue //"idle"
        }
        
        
        if let nextSong = data.songStatus?.next, nextSong.count > 0{
            self.btnNext.setImage(#imageLiteral(resourceName: "next-blue_button"), for: .normal)
            self.btnNext.accessibilityIdentifier = AVPlayerStatus.next.rawValue //"next"
        }else{
            self.btnNext.setImage(#imageLiteral(resourceName: "next_gray_button"), for: .normal)
            self.btnNext.accessibilityIdentifier = AVPlayerStatus.idle.rawValue //"idle"
        }
        
        if let prevsong = data.songStatus?.sngPlIndex, prevsong != "0", prevsong != "1"{
            self.btnPrevious.setImage(#imageLiteral(resourceName: "prev-blue_button"), for: .normal)
            self.btnPrevious.accessibilityIdentifier = AVPlayerStatus.prev.rawValue // "prev"
        }else{
            self.btnPrevious.setImage(#imageLiteral(resourceName: "prev_gray_button"), for: .normal)
            self.btnPrevious.accessibilityIdentifier = AVPlayerStatus.idle.rawValue //"idle"
        }
        
        if let shuffle = data.songStatus?.shuffle, let sngPlIndex = data.songStatus?.sngPlIndex, shuffle.count > 0, sngPlIndex != "0"{
            self.btnShuffle.setImage((shuffle == "1" ? #imageLiteral(resourceName: "shuffle_blue_button") : #imageLiteral(resourceName: "shuffle_gray_button")), for: .normal)
            self.btnShuffle.accessibilityIdentifier = shuffle //(shuffle == "1") ? "shuffle_on" : "shuffle_off"
        }else{
            self.btnShuffle.setImage(#imageLiteral(resourceName: "shuffle_gray_button"), for: .normal)
            self.btnShuffle.accessibilityIdentifier = AVPlayerStatus.idle.rawValue //"idle"
        }
        
        if let totalTime = data.songStatus?.time, let totalElapsedTime = data.songStatus?.elapsed, totalTime.count > 0, totalTime != "0", totalElapsedTime.count > 0, totalElapsedTime != "0" {
            
            let mediaEndTime = Int32(totalTime)! // it is in seconds
            self.lblMediaEndTime.text = "\(self.formatTimeFromSeconds(totalSeconds: mediaEndTime))"
            
            self.sliderOfMediaPlayer.maximumValue = Float(Int32(totalTime)!*1000) // it is in seconds
            self.sliderOfMediaPlayer.minimumValue = Float(0)
            
            let mediaStartTime = Int32(totalElapsedTime)!/1000 // it is in milliseconds
            self.lblMediaStartTime.text = "\(self.formatTimeFromSeconds(totalSeconds: mediaStartTime))"
            
            self.sliderOfMediaPlayer.setValue(Float(totalElapsedTime)!, animated: true)
        }else{
            let totalTime = "0"
            let totalElapsedTime = "0"
            
            let mediaEndTime = Int32(totalTime)! // it is in seconds
            self.lblMediaEndTime.text = "\(self.formatTimeFromSeconds(totalSeconds: mediaEndTime))"
            
            self.sliderOfMediaPlayer.maximumValue = Float(Int32(totalTime)!*1000) // it is in seconds
            self.sliderOfMediaPlayer.minimumValue = Float(0)
            
            let mediaStartTime = Int32(totalElapsedTime)!/1000 // it is in milliseconds
            self.lblMediaStartTime.text = "\(self.formatTimeFromSeconds(totalSeconds: mediaStartTime))"
            
            self.sliderOfMediaPlayer.setValue(Float(totalElapsedTime)!, animated: true)
        }
    }
    
    //MARK: Update back button Color as per moving backward/forward
    func updateBackButtonUI(path:String){
        //
        self.btnBack.alpha = (path == "") ? 0.3 : 1.0
    }
    
    //MARK: Initialization arrays,...
    func initialization(){
        //
        self.initializeArrays()
    }
    
    //MARK: Initializa arrays like  mediaPresets, presets
    private func initializeArrays(){
        //
        for mediaPresets in ModelHome.mediaPresets{
            self.arrMediaPresets.append(MediaPresets(name:mediaPresets.localized,isSelected:false))
        }
        
        for preset in ModelHome.presets{
            self.arrPresets.append(Presets(name:preset["name"]!,isSelected:false,value:preset["value"]!))
        }
        
        // default media is selected
        self.arrMediaPresets[0].isSelected = true
    }
    
    //MARK: Update item list (folders and songs list)
    func updateItemList(completion: (Bool) -> ()){
        //
        guard SelectedItemDetails.elementType != .song else { return; } // do not enter if song selected
        guard SelectedItemDetails.roomIndex > -1 else { return; } // rooms must not be empty
        let room = ModelHome.availableRooms[SelectedItemDetails.roomIndex]
        guard SelectedItemDetails.inputSourceIndex > -1 else { return; } // input sources must not be empty
        let inputSource = room.inputSources[SelectedItemDetails.inputSourceIndex]
        
        self.arrMedias = []
        let path = SelectedItemDetails.selectedPath
        self.arrMedias = (path == "") ? inputSource.menuList.filter{$0.idPath == "media" } : inputSource.menuList.filter{$0.idPath == "media>" + path}
        completion(true)
    }
    
    //MARK: Format second value to hour/min/sec value
    private func formatTimeFromSeconds(totalSeconds: Int32) -> String {
        //
        let seconds: Int32 = totalSeconds%60
        let minutes: Int32 = (totalSeconds/60)%60
        let hours: Int32 = totalSeconds/3600
        return String(format: "%02d:%02d:%02d", hours,minutes,seconds)
    }
    
    @objc func callCommandGetSongItem(_ notification: NSNotification){
        var params = [String:Any]()
        params = notification.userInfo as! [String : Any]
        print("called function in vcplaylistplayer \(String(describing: params))")
        // let roomName = params["roomName"] as! String
        let iSource = params["iSource"] as! String
        let startC = params["startC"] as! String
        let endC = params["endC"] as! String
        let sPath = params["sPath"] as! String
        let broadcastAddress = params["broadcastAddress"] as! String
        let portNum = params["portNum"] as! UInt16
        
        let startCount:Int = Int(startC)!
        let endCount: Int  = Int(endC)!
        //   var maxEnd:Int = ( endCount > Int(DefaultValues.maxEndCount)! ) ? endCount : Int(DefaultValues.maxEndCount)!
        
        maxEnd = endCount
        print("max End \(maxEnd)")
        var strideBy:Int = 5
        if maxEnd <= 10 {
            strideBy = 1
        }else {
            strideBy = 5
        }
        for index in stride(from: startCount, to: maxEnd, by: strideBy){
            var signal: String = ""
            let concurrentOperation = ConcurrentOperation { _ in
                signal = Query.getSourceMenuListForPathQuery(sourceName:iSource,
                                                             path:sPath,
                                                             start: String(index),
                                                             end: String(index + strideBy))
                BroadcastSocket.sharedBroadcastSocket.send(signalStr:signal, ipAddress:broadcastAddress, port:portNum)
            }
            concurrentOperation.addToQueue(queue)
            concurrentOperation.waitUntilFinished()
        }
    }
    @objc func resumePauseQueueLoading(_ notification: NSNotification){
        //  self.cellSongListTableView.reloadData()
        queue.resume()
    }
    // MARK:- Queue operation managment
    func suspendQueue() -> Void {
        queue.pause()
    }
    func resumeQueue() -> Void {
        queue.resume()
    }
    func cancelQueue() -> Void {
        queue.cancelAll()
    }
    @objc func appendSong() {
        /*  guard self.items.count != 0 else {
         self.showNoSongAlert(msg: "No Song in selected playlist.")
         return; }*/
        suspendQueue()
        self.cellSongListTableView.reloadData()
        resumeQueue()
    }
    // Reload table
    func reloadTableData() {
        self.updateItemList( completion: { (success) -> Void in
            if success { // this will be equal to whatever value is set in this method call
                //print("true")
                self.items = self.loadSongsDividedByTitle()
                /*  guard self.items.count != 0 else {
                 return;
                 }*/
                var difference = 0
                var timer = Timer()
                var timeInterval1: Double = 2.0
                let countItems = self.items.count
                difference = countItems - VCPlaylistWithPlayer.totalSong
                if countItems > 0 && countItems < 10 {
                    timeInterval1 = 2.0
                }else if countItems > 10 && countItems < 1000{
                    timeInterval1 = 15.0
                }else if countItems > 1000 && countItems < 10000 {
                    timeInterval1 = 55.0
                }
                /* if isSearch && isSearchTxt {
                 filteredSong = items
                 searchBar.text = ""
                 searchBar.resignFirstResponder()
                 
                 }*/
                // print("Differences is \(difference) ItemsCount \(countItems) totalSong \(VCPlaylistWithPlayer.totalSong)")
                
                if self.items.count == maxEnd  {
                    timer.invalidate()
                    
                }else if isReset {
                    self.items.removeAll()
                    self.items = self.loadSongsDividedByTitle()
                    appendSong()
                }
                else {
                    timer = Timer.scheduledTimer(timeInterval: timeInterval1, target: self, selector: #selector(appendSong), userInfo: nil, repeats: false)
                }
            } else {
                //print("false")
            }
        })
    }
}
// MARK:- Extension for UIScrollView
extension VCPlaylistWithPlayer: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //1
        suspendQueue()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 2
        if !decelerate {
            resumeQueue()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 3
        resumeQueue()
    }
}


// MARK:- Extension for UITableViewDelegate
extension VCPlaylistWithPlayer: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //
        // tableView.tableViewEmptyLabel(count: items.count)
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Its calling again again")
        //
        //print("List for notifcation is \(NotificationCenter.observationInfo())")
        if isSearch && isSearchTxt {
            return filteredSong.count
        }
        VCPlaylistWithPlayer.totalSong = items.count
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSongListTableViewCell")as! CellSongListTableViewCell //1.
        
        hud.hide(animated: true)
        let search_Song: MenuResp
        
        if isSearch && isSearchTxt {
            search_Song = filteredSong[indexPath.row]
        }else{
            search_Song = items[indexPath.row]
        }
        cell.setMediaValues(values: search_Song)
        
        if isSearch && isSearchTxt{
            cell.lblSongName.text = cell.lblSongName.text! + " " + "Total Count: \(filteredSong.count )."
        }else{
            cell.lblSongName.text = cell.lblSongName.text! + " " + "Total Count: \(items.count )."
        }
        return cell //4.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        var selectedSong: MenuResp
        /* if searchController.isActive && searchController.searchBar.text != "" {
         selectedSong = filteredSong[indexPath.row]
         }else{
         selectedSong = items[indexPath.row]
         }*/
        
        if items.count > indexPath.row {
            
            homeVC?.isNeedToStopSongsReq = false
            if isSearch && isSearchTxt {
                selectedSong = filteredSong[indexPath.row]
            } else {
                selectedSong = items[indexPath.row]
            }
            
            if self.arrMediaPresets[0].isSelected!{ // Media selected
                let tmp = selectedSong
                guard let elementName = tmp.elementName, let element = Element(rawValue: elementName) else{return}
                switch(element){
                // not allowed for selection (for sub-menus)
                case .report,.source,.error,.equalizer,.volume,.restore,.none : break;
                case .currentSong,.active,.mute,.amp,.audioSetting,.loudness: break;
                case .next, .prev, .play, .pause, .stop, .shuffle : break;
                case .multiRoomCreate, .multiRoomJoin, .multiRoomLeave, .multiRoomCancel : break;
                case .multiRoomVolume, .multiRoomMute, .multiRoomAmp, .multiRoomPowerOnOff: break;
                case .favourite: break;
                case .item : //  folders and their subfolders
                    guard let id = tmp.id else{return}
                    isReset = true
                    cancelQueue()
                    let path = SelectedItemDetails.selectedPath
                    SelectedItemDetails.selectedPath = (path == "") ? id : (path + ">" + id)
                    ModelHome.availableRooms[SelectedItemDetails.roomIndex].selectedPath = SelectedItemDetails.selectedPath
                    
                    SelectedItemDetails.start = DefaultValues.startcount
                    if let noOfChildrens = tmp.children{
                        SelectedItemDetails.end = (noOfChildrens == "0") ? DefaultValues.endCount : noOfChildrens
                    }else{
                        SelectedItemDetails.end = DefaultValues.endCount
                    }
                    SelectedItemDetails.selectedSongPath = ""
                    SelectedItemDetails.elementType = .item
                    
                    tempPath = SelectedItemDetails.selectedPath
                    endCount = SelectedItemDetails.end
                    self.updateBackButtonUI(path: SelectedItemDetails.selectedPath)
                    let notif = NotificationCenter.default
                    
                    notif.post(name: .socketCallFromContainer, object: nil, userInfo: [:])
                    reloadTableData()
                case .song: // for songs
                    guard let id = tmp.id else{ return }
                    homeVC?.isNeedToStopSongsReq = true
                    if SelectedItemDetails.end > endCount {
                        endCount = SelectedItemDetails.end
                    }
                    suspendQueue()
                    let path = SelectedItemDetails.selectedPath
                    SelectedItemDetails.selectedSongPath = (path == "") ? id : (path + ">" + id)
                    SelectedItemDetails.elementType = .song
                    self.updateBackButtonUI(path: SelectedItemDetails.selectedPath)
                    let notif = NotificationCenter.default
                    notif.post(name: .socketCallFromContainer, object: nil, userInfo: [:])
                    
                }
            }else{ // Presets list selected
                for (i,_) in self.arrPresets.enumerated(){
                    self.arrPresets[i].isSelected = (i == indexPath.row) ? true : false
                }
                reloadTableData()
            }
        }
    }
}
//MARK: UISearchbar delegate
extension VCPlaylistWithPlayer: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        isSearch = true;
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            isSearchTxt = true
            
            filteredSong.removeAll(keepingCapacity: false)
            
            self.filteredSong = items.filter({( searchSong : MenuResp) -> Bool in
                return (searchSong.display?.lowercased().contains(searchText.lowercased()))!
            })
            
            self.cellSongListTableView.reloadData()
        }else{
            searchBar.resignFirstResponder()
            isSearchTxt = false
            isSearch = false;
            filteredSong.removeAll(keepingCapacity: false)
            
            filteredSong = items
            
            self.cellSongListTableView.reloadData()
        }
    }
}

// MARK:- Extension for UICollectionViewDelegate
extension VCPlaylistWithPlayer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Collection view methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        switch collectionView.tag {
            
        case 11: // MediaPresets
            return self.arrMediaPresets.count;
        case 12: // Medias : Presets
            return (self.arrMediaPresets[0].isSelected!) ? self.arrMedias.count : 0
        default:
            return 0;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        switch collectionView.tag {
        case 11: // Media/Presets Heading collectionView
            let cellMediaPresetsCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "CellMediaPresetsCollectionView", for: indexPath) as! CellMediaPresetsCollectionView
            cellMediaPresetsCollectionView.setValues(values: self.arrMediaPresets[indexPath.item])
            // Show rearrange button for media only
            self.btnRearrange.isHidden = (self.arrMediaPresets[0].isSelected!) ? false : true
            return cellMediaPresetsCollectionView;
        case 12: // Medias/Presets songs collectionView
            if self.arrMediaPresets[0].isSelected!{ // Medias
                if self.isMediaArrangedWithList{ // listview
                    let cellSongListCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSongListCollectionView", for: indexPath) as! CellSongListCollectionView
                    cellSongListCollectionView.isSelected = false
                    self.cellSongListTableView.isHidden = true
                    self.cellSongListTableView.reloadData()
                    
                    //  cellSongListCollectionView.cellSongListTableView.register(UINib(nibName: "songList", bundle: nil), forCellReuseIdentifier: "CellSongListTableViewCell")
                    // cellSongListCollectionView.cellSongListTableView.reloadData()
                    //   cellSongListCollectionView.setMediaValues(values: self.arrMedias[indexPath.item])
                    return cellSongListCollectionView;
                }else{ // tilesview
                    let cellSongCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSongCollectionView", for: indexPath) as! CellSongCollectionView
                    cellSongCollectionView.setMediaValues(values: self.arrMedias[indexPath.item])
                    //786
                    
                    cellSongCollectionView.lblSongName.text = "\(indexPath.row). " + cellSongCollectionView.lblSongName.text!
                    //print("song Name \(cellSongCollectionView.lblSongName.text)")
                    return cellSongCollectionView;
                }
            }else{ // Presets listview
                let cellPresetCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPresetCollectionView", for: indexPath) as! CellPresetCollectionView
                cellPresetCollectionView.setPresetValues(values: self.arrPresets[indexPath.item])
                return cellPresetCollectionView;
            }
        default:
            return UICollectionViewCell();
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //
        switch collectionView.tag {
        case 11: // Media Presets Heading
            return CGSize(width:self.collectionVwMediaPresets.frame.width*0.15, height:self.collectionVwMediaPresets.frame.height);
        case 12: // Medias or presets songs
            if self.arrMediaPresets[0].isSelected!{ // Medias
                if self.isMediaArrangedWithList{ // listview
                    return CGSize(width: self.collectionVwSongs.frame.width, height: self.collectionVwSongs.frame.height - 10)
                    // return CGSize(width:self.collectionVwSongs.frame.width, height:self.collectionVwSongs.frame.width*0.06);
                }else{ // tilesview
                    return CGSize(width:self.collectionVwSongs.frame.width*0.12, height:self.collectionVwSongs.frame.width*0.15);
                }
            }else{ //Presets list
                return CGSize(width:self.collectionVwSongs.frame.width, height:self.collectionVwSongs.frame.width*0.05);
            }
        default:
            return CGSize.zero;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 11: // Media/Presets heading
            for (i,_) in self.arrMediaPresets.enumerated(){
                self.arrMediaPresets[i].isSelected = (i == indexPath.item) ? true : false
            }
            self.collectionVwMediaPresets.reloadData()
            self.collectionVwSongs.reloadData()
        case 12: // Medias/presets songs list
            if self.arrMediaPresets[0].isSelected!{ // Media selected
                let tmp = self.arrMedias[indexPath.item]
                guard let elementName = tmp.elementName, let element = Element(rawValue: elementName) else{return}
                switch(element){
                // not allowed for selection (for sub-menus)
                case .report,.source,.error,.equalizer,.volume,.restore,.none : break;
                case .currentSong,.active,.mute,.amp,.audioSetting,.loudness: break;
                case .next, .prev, .play, .pause, .stop, .shuffle : break;
                case .multiRoomCreate, .multiRoomJoin, .multiRoomLeave, .multiRoomCancel : break;
                case .multiRoomVolume, .multiRoomMute, .multiRoomAmp, .multiRoomPowerOnOff: break;
                case .favourite: break;
                case .item : //  folders and their subfolders
                    guard let id = tmp.id else{return;}
                    let path = SelectedItemDetails.selectedPath
                    SelectedItemDetails.selectedPath = (path == "") ? id : (path + ">" + id)
                    ModelHome.availableRooms[SelectedItemDetails.roomIndex].selectedPath = SelectedItemDetails.selectedPath
                    
                    SelectedItemDetails.start = DefaultValues.startcount
                    if let noOfChildrens = tmp.children{
                        SelectedItemDetails.end = (noOfChildrens == "0") ? DefaultValues.endCount : noOfChildrens
                    }else{
                        SelectedItemDetails.end = DefaultValues.endCount
                    }
                    //                    //TausifsngPlTotal
                    //                    if let sngPlTotal = currentPlayingSong?.sngPlTotal{
                    //                        SelectedItemDetails.end = sngPlTotal
                    //                    }
                    
                    
                    SelectedItemDetails.selectedSongPath = ""
                    SelectedItemDetails.elementType = .item
                    let notif = NotificationCenter.default
                    notif.post(name: .socketCallFromContainer, object: nil, userInfo: [:])
                    self.cellSongListTableView.reloadData()
                    self.updateBackButtonUI(path: SelectedItemDetails.selectedPath)
                    reloadTableData()
                case .song: // for songs
                    guard let id = tmp.id else{return}
                    let path = SelectedItemDetails.selectedPath
                    SelectedItemDetails.selectedSongPath = (path == "") ? id : (path + ">" + id)
                    SelectedItemDetails.elementType = .song
                    let notif = NotificationCenter.default
                    notif.post(name: .socketCallFromContainer, object: nil, userInfo: [:])
                    self.collectionVwSongs.reloadData()
                }
            }else{ // Presets list selected
                for (i,_) in self.arrPresets.enumerated(){
                    self.arrPresets[i].isSelected = (i == indexPath.item) ? true : false
                }
            }
        default:
            break;
        }
    }
}

//MARK: Media/Audio Player
extension VCPlaylistWithPlayer{
    
    @IBAction func onPlayPauseReload(_ sender: UIButton) {
        //
        guard let controlState = sender.accessibilityIdentifier else{return}
        guard let state = AVPlayerStatus(rawValue: controlState.lowercased()) else {return;}
        switch state{
        case .play: // Used for Play
            SelectedItemDetails.elementType = .play
            var data : [String:Any] = [:]
            data["controlState"] = true
            let notif = NotificationCenter.default
            notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
        case .pause: // Used for Pause
            SelectedItemDetails.elementType = .pause
            var data : [String:Any] = [:]
            data["controlState"] = true
            let notif = NotificationCenter.default
            notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
        case .idle, .reload, .stop, .next, .prev:
            break;
        }
        
    }
    
    @IBAction func onStop(_ sender: UIButton) {
        //
        guard let controlState = sender.accessibilityIdentifier, controlState == AVPlayerStatus.stop.rawValue else {return;}
        SelectedItemDetails.elementType = .stop
        var data : [String:Any] = [:]
        data["controlState"] = true
        let notif = NotificationCenter.default
        notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    @IBAction func onShuffle(_ sender: UIButton) {
        //
        guard let controlState = sender.accessibilityIdentifier, controlState != AVPlayerStatus.idle.rawValue else {return;}
        SelectedItemDetails.elementType = .shuffle
        var data : [String:Any] = [:]
        data["status"] = (controlState == "1") ? true : false
        data["controlState"] = true
        let notif = NotificationCenter.default
        notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    @IBAction func onPrevious(_ sender: UIButton) { // Used for Previous
        //
        guard let controlState = sender.accessibilityIdentifier, controlState == AVPlayerStatus.prev.rawValue else {return;}
        SelectedItemDetails.elementType = .prev
        var data : [String:Any] = [:]
        data["controlState"] = true
        let notif = NotificationCenter.default
        notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    @IBAction func onNext(_ sender: UIButton) { // Used for Next
        //
        guard let controlState = sender.accessibilityIdentifier, controlState == AVPlayerStatus.next.rawValue else {return;}
        SelectedItemDetails.elementType = .next
        var data : [String:Any] = [:]
        data["controlState"] = true
        let notif = NotificationCenter.default
        notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    @IBAction func onMediaPlayerSliderChanged(_ sender: UISlider) {
        //
        /*
         guard let controlState = sender.accessibilityIdentifier else{return}
         guard let state = AVPlayerStatus(rawValue: controlState.lowercased()) else {return;}
         SelectedItemDetails.elementType = .pause
         var data : [String:Any] = [:]
         data["controlState"] = true
         let notif = NotificationCenter.default
         notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
         switch state{
         case .play: // Used for Play
         SelectedItemDetails.elementType = .play
         var data : [String:Any] = [:]
         data["controlState"] = true
         let notif = NotificationCenter.default
         notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
         case .pause: // Used for Pause
         SelectedItemDetails.elementType = .pause
         var data : [String:Any] = [:]
         data["controlState"] = true
         let notif = NotificationCenter.default
         notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
         case .idle, .reload, .stop, .next, .prev:
         break;
         }*/
        
    }
}
// MARK:- Table View Helper methods
extension UITableView {
    // Add and remove Lable on count with title
    func tableViewEmptyLabel( count: Int,  clr: UIColor = UIColor.lightGray,  fontSize: CGFloat = 15,  strText: String = "No data available") {
        //
        if count > 0{
            self.backgroundView = nil
        } else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            noDataLabel.font            = UIFont.systemFont(ofSize: fontSize)
            noDataLabel.text            = strText
            noDataLabel.numberOfLines   = 0
            noDataLabel.textColor       = clr
            noDataLabel.textAlignment   = .center
            self.backgroundView         = noDataLabel
        }
    }
} //extension
