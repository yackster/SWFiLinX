//
//  VCMultiroomOption.swift
//  iLinX
//
//  Created by Vikas Ninawe on 30/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

class VCMultiroomOption: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var btnCreateCancel: UIButton!
    @IBOutlet weak var btnJoinLeave: UIButton!
    @IBOutlet weak var lblMultiRoomName: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var vwPopUp: UIView!
    @IBOutlet weak var btnCloseCorner: UIButton!
    
    @IBOutlet weak var vwConnectionControl: UIView!
    @IBOutlet weak var vwVolumeControl: UIView!
    @IBOutlet weak var btnMuteOnOff: UIButton!
    @IBOutlet weak var btnPowerOff: UIButton!
    @IBOutlet weak var btnAVOnOff: UIButton!
    @IBOutlet weak var sliderVolume: UISlider!
    
    @IBOutlet weak var vwJoinLeave: UIView!
    @IBOutlet weak var vwControls: UIView!
    
    
    var popDelegate:PopOver?
    var info:ComposedType?
    
    let multiRoom = Query.arrMultiRooms[0]
    
    //MARK: View controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwPopUp.layer.cornerRadius = 5.0
        self.vwPopUp.clipsToBounds = true
        //self.btnCloseCorner.setTitle("close".localized, for: .normal)
        
        // Add dropshadow with corner
        self.vwJoinLeave.addShadowAllSide()
        self.vwControls.addShadowAllSideWithoutInsertingView()
        self.vwVolumeControl.layer.cornerRadius = 7
        self.vwVolumeControl.clipsToBounds = true
        
        self.btnJoinLeave.setBorderWithRoundedCorner()
        self.btnCreateCancel.setBorderWithRoundedCorner()
        self.btnPowerOff.setBorderWithRoundedCorner()
        
//        self.btnJoinLeave.layer.cornerRadius = 5.0
//        self.btnJoinLeave.clipsToBounds = true
//        self.btnCreateCancel.layer.cornerRadius = 5.0
//        self.btnCreateCancel.clipsToBounds = true
        
        let notif = NotificationCenter.default
        notif.addObserver(self, selector: #selector(self.updateUI(_:)), name: .uiUpdateContainerMultiroomOption, object: nil)
        notif.addObserver(self, selector: #selector(self.updateSetting(_:)), name: .uiUpdateSetting, object: nil)
        
        //set action target to multiRoom volume slider
        self.sliderVolume.addTarget(self, action: #selector(self.onVolumeSliderChanged(_:_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.lblMultiRoomName.text =  self.multiRoom // Multiroom session name
        
        self.btnJoinLeave.setTitle("join".localized, for: .normal)
        self.btnJoinLeave.accessibilityIdentifier = MultiRoomStatus.join.rawValue
        self.btnJoinLeave.accessibilityValue = self.multiRoom // All rooms session
        
        self.btnCreateCancel.setTitle("cancel".localized, for: .normal)
        self.btnCreateCancel.accessibilityIdentifier = MultiRoomStatus.cancel.rawValue
        self.btnCreateCancel.accessibilityValue = self.multiRoom // All rooms session
        self.btnCreateCancel.isHidden = true
        self.vwControls.isHidden = true
        self.vwVolumeControl.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notif = NotificationCenter.default
        notif.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        // Change slider ThumbeImage
        self.sliderVolume.setThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
        
        //set corner to restore button
        self.btnPowerOff.layer.cornerRadius = 5
        self.btnPowerOff.clipsToBounds = true
        self.btnPowerOff.setTitle("poweroff".localized, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Update setting (Value for all the controls)
    @objc func updateSetting(_ notification: NSNotification) {
        self.setValues()
    }
    //MARK: Show alert (Common for all)
    private func showAlert(msg:String){
        self.presentAlertWithTitle(title:"ilinx".localized, message:msg, options:"ok".localized) { (option) in
            switch(option){
            case 0: break; //print("ok".localized)
            default: break;
            }
        }
    }
    
    //MARK: Set values for controls
    func setValues(){
        guard (SelectedItemDetails.roomIndex > -1) else { return; }
        
        //multiroom join/leave
        let idx = SelectedItemDetails.roomIndex
        
        guard let audioSessionActive = ModelHome.availableRooms[idx].roomSetting?.audioSessionActive else {return}
        if audioSessionActive == "1"{
            self.btnJoinLeave.setTitle("leave".localized, for: .normal)
            self.btnJoinLeave.accessibilityIdentifier = MultiRoomStatus.leave.rawValue
            self.btnCreateCancel.isHidden = false
            self.vwControls.isHidden = false
            self.vwVolumeControl.isHidden = false
            self.btnCreateCancel.setTitle("cancel".localized, for: .normal)
            self.btnCreateCancel.accessibilityIdentifier = MultiRoomStatus.cancel.rawValue
            
            //multiroom mute
            if let muteStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.mute{
                self.btnMuteOnOff.setImage((muteStatus == "1") ? #imageLiteral(resourceName: "volume_off") : #imageLiteral(resourceName: "volume_on"), for: .normal)
            }
            
            //multiroom ampOn
            if let ampOnStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn{
                self.btnAVOnOff.setImage((ampOnStatus == "1") ? #imageLiteral(resourceName: "av_on") : #imageLiteral(resourceName: "av_off"), for: .normal)
            }
            
            //multiroom Volume
            let volume = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.vol
            self.updateVolumeSliderValue(value: volume, callCommand: false)
            
        }else if audioSessionActive == "" || audioSessionActive == "0"{
            self.btnJoinLeave.setTitle("join".localized, for: .normal)
            self.btnJoinLeave.accessibilityIdentifier = MultiRoomStatus.join.rawValue
            self.btnCreateCancel.isHidden = true
            self.vwControls.isHidden = true
            self.vwVolumeControl.isHidden = true
            
        }
    }
    
    //MARK: IBActions
    
    @IBAction func onMuteOnOff(_ sender: UIButton) {
        guard let muteStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.mute else{return}
        let newMuteStatus = (muteStatus == "1") ? "0" : "1"
        ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.mute = newMuteStatus
        self.btnMuteOnOff.setImage((newMuteStatus == "1") ? #imageLiteral(resourceName: "volume_off") : #imageLiteral(resourceName: "volume_on"), for: .normal)

        // Volume MUTE ON/OFF message on touchlinx
        SelectedItemDetails.elementType = .mute
        var data : [String:Any] = [:]
        data["multiRoom"] = self.multiRoom
        data["status"] = (newMuteStatus == "0") ? true : false
        NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    @IBAction func onAVOnOff(_ sender: UIButton) {
        guard let ampOnStatus = ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn else{return}
        let newAmpOnStatus = (ampOnStatus == "1") ? "0" : "1"
        ModelHome.availableRooms[SelectedItemDetails.roomIndex].roomSetting?.ampOn = newAmpOnStatus
        self.btnAVOnOff.setImage((newAmpOnStatus == "1") ? #imageLiteral(resourceName: "av_on") : #imageLiteral(resourceName: "av_off"), for: .normal)

        // Audio ON/OFF message on touchlinx
        SelectedItemDetails.elementType = .multiRoomAmp
        var data : [String:Any] = [:]
        data["multiRoom"] = self.multiRoom
        data["status"] = newAmpOnStatus == "0" ? true : false
        NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    @IBAction func onPowerOff(_ sender: UIButton) {
        // Power ON/OFF
//        SelectedItemDetails.elementType = .multiRoomPowerOnOff
//        var data : [String:Any] = [:]
//        data["multiRoom"] = self.multiRoom
//        NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        self.popDelegate?.onPop(info: self.info)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreateCancel(_ sender: UIButton) {
        guard (SelectedItemDetails.roomIndex > -1) else {return;}
        
        guard let controlState = sender.accessibilityIdentifier else{return}
        guard let state = MultiRoomStatus(rawValue: controlState.lowercased()) else {return;}
        switch state{
        case .create: // Used for Create
            SelectedItemDetails.elementType = .multiRoomCreate
            var data : [String:Any] = [:]
            data["multiRoom"] = self.multiRoom
            NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
        case .cancel: // Used for Cancel
            SelectedItemDetails.elementType = .multiRoomCancel
            var data : [String:Any] = [:]
            data["multiRoom"] = self.multiRoom
            NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
        case .idle, .join, .leave:
            break;
        }
    }
    
    @IBAction func onJoinLeave(_ sender: UIButton) {
        guard (SelectedItemDetails.roomIndex > -1) else {return;} // Room must be selected
        guard SelectedItemDetails.inputSourceIndex > -1 else { // Source must be selected
            self.showAlert(msg: "selectinputsourcefirst".localized)
            return
        }
        
        guard let controlState = sender.accessibilityIdentifier else{return}
        guard let state = MultiRoomStatus(rawValue: controlState.lowercased()) else {return;}
        switch state{
        case .join: // Used for Join
            SelectedItemDetails.elementType = .multiRoomJoin
            var data : [String:Any] = [:]
            data["multiRoom"] = self.multiRoom
            NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
        case .leave: // Used for Leave
            SelectedItemDetails.elementType = .multiRoomLeave
            var data : [String:Any] = [:]
            data["multiRoom"] = self.multiRoom
            NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
        case .idle, .create, .cancel:
            break;
        }
    }
    
    //MARK: Auxillary methods
    
    //MARK: Update vloume on slider changed (Actual call)
    private func updateVolumeSliderValue(value:String?, callCommand:Bool){
        self.sliderVolume.setValue(Float(value ?? "0.0")!.rounded(), animated: true)

        guard callCommand else { return; }
        let finalValue = Int(Float(value ?? "0.0")!.rounded())
        
        SelectedItemDetails.elementType = .multiRoomVolume
        var data : [String:Any] = [:]
        data["value"] = String(finalValue)
        data["multiRoom"] = self.multiRoom
        NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
    //MARK: Volume changes on slider moves
    @objc func onVolumeSliderChanged(_ sender: UISlider, _ event: UIEvent) {
        guard let touchEvent = event.allTouches?.first else{return}
        switch touchEvent.phase {
        case .began:
            break;
        case .moved:
            let finalValue = Int(Float(sender.value).rounded())
            guard finalValue%5 == 0 else{ return; } // call on every 5th step
            self.updateVolumeSliderValue(value: String(sender.value), callCommand: true)
        case .ended:
            self.updateVolumeSliderValue(value: String(sender.value), callCommand: true)
        default:
            break;
        }
    }
    
    //MARK: Update UI notification received for container
    @objc func updateUI(_ notification: NSNotification) {
        //self.viewWillAppear(true)
    }

}
