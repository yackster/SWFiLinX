//
//  VCMediaSetting.swift
//  iLinX
//
//  Created by Vikas Ninawe on 30/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

class VCMediaSetting: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCloseCorner: UIButton!
    @IBOutlet weak var vwPopUp: UIView!
    @IBOutlet var lblArrEqualizerName: [UILabel]!
    @IBOutlet var lblArrEqualizerMaxValues: [UILabel]!
    @IBOutlet var lblArrEqualizerMinValues: [UILabel]!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var btnAVOnOff: UIButton!
    @IBOutlet weak var btnMuteOnOff: UIButton!
    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var vwVolumeBg: UIView!
    @IBOutlet weak var vwPresetBg: UIView!
    @IBOutlet weak var vwEqualizerBg: UIView!
    @IBOutlet weak var collectionVwPresets: UICollectionView!
    @IBOutlet var arrEqualizerSlider: [UISlider]!{
        didSet{
            let _ = self.arrEqualizerSlider.enumerated().map({
                guard $0 < 3 else { return; } //  set vertical only for first 3
                $1.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
            })
        }
    }
    
    //MARK: Variables and Flags
    
    var arrEqualizerNames = ["balance", "bass", "trouble", "band"]
    var arrPresets = [Presets]()
    var arrSettingControls = Query.arrSettingControls
    var popDelegate:PopOver?
    var info:ComposedType?
    
    //MARK: View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwPopUp.layer.cornerRadius = 5.0
        self.vwPopUp.clipsToBounds = true
        //self.btnCloseCorner.setTitle("close".localized, for: .normal)
        
        self.vwVolumeBg.addShadowAllSide()
        self.btnRestore.setBorderWithRoundedCorner()
        
        self.collectionVwPresets.delegate = self
        self.collectionVwPresets.dataSource = self
        
        let notif = NotificationCenter.default
        notif.addObserver(self, selector: #selector(self.updateUI(_:)), name: .uiUpdateContainerMediaSetting, object: nil)
        notif.addObserver(self, selector: #selector(self.updateSetting(_:)), name: .uiUpdateSetting, object: nil)
        
        // set action target to equalizer sliders
        for slider in self.arrEqualizerSlider{
            slider.addTarget(self, action: #selector(self.onEqualizerSliderChanged(_:_:)), for: .valueChanged)
        }
        
        //set action target to volume slider
        self.sliderVolume.addTarget(self, action: #selector(self.onVolumeSliderChanged(_:_:)), for: .valueChanged)
        
        self.initializeArrays()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setValues()
    }
    
    override func viewWillLayoutSubviews() {
        // Set Names to equalizer
        for (i,v) in self.lblArrEqualizerName.enumerated(){
            v.text = self.arrEqualizerNames[i].localized
            v.textColor = .iLinXBlueColor
        }
        
        // Hide Equalizer slider min values
        let _ = self.lblArrEqualizerMinValues.map({$0.isHidden = true})
        
        // Change slider ThumbeImage
        let _ = self.arrEqualizerSlider.enumerated().map({
            $1.setThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
            $1.tag = $0
        })
        self.sliderVolume.setThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
        
        //set corner to restore button
        self.btnRestore.layer.cornerRadius = 5
        self.btnRestore.clipsToBounds = true
        self.btnRestore.setTitle("restore".localized, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notif = NotificationCenter.default
        notif.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Auxillary methods
    
    //MARK: Update UI on notification received for container
    @objc func updateUI(_ notification: NSNotification) {
        
    }
    
    //MARK: Update setting (Value for all the controls)
    @objc func updateSetting(_ notification: NSNotification) {
        self.setValues()
    }
    
    //MARK: Initialize arrays like  presets,...
    private func initializeArrays(){
        for preset in ModelHome.presets{
            self.arrPresets.append(Presets(name:preset["name"]!, isSelected: false,value:preset["value"]!))
        }
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        self.popDelegate?.onPop(info:self.info)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onMuteOnOff(_ sender: UIButton) {
        guard let muteStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.mute else{return}
        let newMuteStatus = (muteStatus == "1") ? "0" : "1"
        ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.mute = newMuteStatus
        self.btnMuteOnOff.setImage((newMuteStatus == "1") ? #imageLiteral(resourceName: "volume_off") : #imageLiteral(resourceName: "volume_on"), for: .normal)
       
        // Volume MUTE ON/OFF message on touchlinx
        SelectedItemDetails.elementType = .mute
        var data : [String:Any] = [:]
        data["status"] = (newMuteStatus == "0") ? true : false
        NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    @IBAction func onAVOnOff(_ sender: UIButton) {
        guard let ampOnStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn else{return}
        let newAmpOnStatus = (ampOnStatus == "1") ? "0" : "1"
        ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn = newAmpOnStatus
        self.btnAVOnOff.setImage((newAmpOnStatus == "1") ? #imageLiteral(resourceName: "av_on") : #imageLiteral(resourceName: "av_off"), for: .normal)
        
        // Audio ON/OFF message on touchlinx
        SelectedItemDetails.elementType = .amp
        var data : [String:Any] = [:]
        data["status"] = newAmpOnStatus == "0" ? true : false
        NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    @IBAction func onRestore(_ sender: UIButton) {
        // Restore original setting
//        SelectedItemDetails.elementType = .restore
//        var data : [String:Any] = [:]
//        NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    //MARK: Volume changes on slider moves
    @objc func onVolumeSliderChanged(_ sender: UISlider, _ event: UIEvent) {
        guard let touchEvent = event.allTouches?.first else{return}
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
    
    //MARK: equalizer(Balance, Bass, Trouble, Band-1,2,3,4,5 ) changes on slider moves
    @objc func onEqualizerSliderChanged(_ sender: UISlider, _ event: UIEvent) {
        guard let touchEvent = event.allTouches?.first else{return}
        switch touchEvent.phase {
        case .began:
            var data : [String:Any] = [:]
            data["isPause"] = true
            let notif = NotificationCenter.default
            notif.post(name: .pauseResumeRoomStatusTimer, object: nil, userInfo: data)
        case .moved:
            let finalValue = Int(Float(sender.value).rounded())
            guard finalValue%5 == 0 else{ return; } // call on every 5th step
            self.updateEqualizerSliderValues(index: sender.tag, value: String(sender.value), callCommand: true)
        case .ended:
            self.updateEqualizerSliderValues(index: sender.tag, value: String(sender.value), callCommand: true)
            
            var data : [String:Any] = [:]
            data["isPause"] = false
            let notif = NotificationCenter.default
            notif.post(name: .pauseResumeRoomStatusTimer, object: nil, userInfo: data)
        default:
            break;
        }
    }
    
    //MARK: Set values to controls
    func setValues(){
        guard (SelectedItemDetails.roomIndex > -1) else { return; }
        
        //mute
        if let muteStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.mute{
            self.btnMuteOnOff.setImage((muteStatus == "1") ? #imageLiteral(resourceName: "volume_off") : #imageLiteral(resourceName: "volume_on"), for: .normal)
        }
        
        //ampOn
        if let ampOnStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn{
            self.btnAVOnOff.setImage((ampOnStatus == "1") ? #imageLiteral(resourceName: "av_on") : #imageLiteral(resourceName: "av_off"), for: .normal)
        }
    
        //Balance
        let balance = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.balance
        self.updateEqualizerSliderValues(index:0, value:balance, callCommand: false)

        //Bass
        let bass = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.bass
        self.updateEqualizerSliderValues(index:1, value:bass, callCommand: false)
        
        //Trouble
        let treb = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.treb
        self.updateEqualizerSliderValues(index:2, value:treb, callCommand: false)
        
        //band_1 
        let band_1 = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.band_1
        self.updateEqualizerSliderValues(index:3, value:band_1, callCommand: false)
        
        //band_2
        let band_2 = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.band_2
        self.updateEqualizerSliderValues(index:4, value:band_2, callCommand: false)
        
        //band_3
        let band_3 = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.band_3
        self.updateEqualizerSliderValues(index:5, value:band_3, callCommand: false)
        
        //band_4
        let band_4 = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.band_4
        self.updateEqualizerSliderValues(index:6, value:band_4, callCommand: false)
        
        //band_5
        let band_5 = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.band_5
        self.updateEqualizerSliderValues(index:7, value:band_5, callCommand: false)
        
        //Volume
        let volume = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.vol
        self.updateVolumeSliderValue(value: volume, callCommand: false)
    }
    
    //MARK: Update equalizer on slider changed (Actual call)
    private func updateEqualizerSliderValues(index:Int, value:String?, callCommand:Bool){
        guard let equiValue = value  else { return; }
        self.arrEqualizerSlider[index].setValue(Float(equiValue)!.rounded(), animated: true)
        let finalValue = Int(Float(equiValue)!.rounded())
        if index < 3 { // for band, there is no labels
           self.lblArrEqualizerMaxValues[index].text = "\(finalValue)"
        }else{ // for band label
            self.lblArrEqualizerMaxValues[3].text = "0"
            self.lblArrEqualizerMaxValues[3].isHidden = true
        }
        
        guard callCommand else { return; }
        SelectedItemDetails.elementType = .equalizer
        var data : [String:Any] = [:]
        data["value"] = String(finalValue)
        data["settingControl"] = self.arrSettingControls[index]
        let notif = NotificationCenter.default
        notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    //MARK: Update vloume on slider changed (Actual call)
    private func updateVolumeSliderValue(value:String?, callCommand:Bool){
        guard let volValue = value else { return; }
        self.sliderVolume.setValue(Float(volValue)!.rounded(), animated: true)
        
        guard callCommand else { return; }
        let finalValue = Int(Float(volValue)!.rounded())
        SelectedItemDetails.elementType = .volume
        var data : [String:Any] = [:]
        data["value"] = String(finalValue)
        data["settingControl"] = self.arrSettingControls.last // last index value for volume
        let notif = NotificationCenter.default
        notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    //MARK: Update equalizer on preset changes (Actual call)
    private func updateEqualizerSliderValuesOnPreset(value:String?){
        SelectedItemDetails.elementType = .loudness
        var data : [String:Any] = [:]
        data["value"] = value
        let notif = NotificationCenter.default
        notif.post(name: .socketCallFromContainer, object: nil, userInfo: data)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
            // Get audio setting for room
            SelectedItemDetails.elementType = .audioSetting
            let notif = NotificationCenter.default
            notif.post(name: .socketCallFromContainer, object: nil, userInfo: [:] as [String:Any])
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            self.setValues()
            self.collectionVwPresets.reloadData()
        })
    }
}

extension VCMediaSetting: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //MARK: Collection view methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPresets.count; // Presets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellPresetCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPresetCollectionView", for: indexPath) as! CellPresetCollectionView
        cellPresetCollectionView.setPresetValues(values: self.arrPresets[indexPath.item])
        return cellPresetCollectionView;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:self.collectionVwPresets.frame.width*0.17, height:self.collectionVwPresets.frame.height);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.updateEqualizerSliderValuesOnPreset(value:self.arrPresets[indexPath.row].value)
    }
}

