//
//  VCStartUp.swift
//  iLinX
//
//  Created by Vikas Ninawe on 30/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit
import MessageUI
import MBProgressHUD
class VCStartUp: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var manualButton: UIButton!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var waitingLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    typealias CompletionHandler = (_ success:Bool) -> Void
    @IBOutlet weak var manualLineView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var autoLineView: UIView!
    @IBOutlet weak var vwAutoConnect: UIView!
    @IBOutlet weak var vwManualConnect: UIView!
    @IBOutlet weak var lblAutoConnect: UILabel!
    @IBOutlet weak var btnAutoConnect: UIButton!
    @IBOutlet weak var btnAutoReconnect: UIButton!
    @IBOutlet weak var btnAutoConnectedInStatus: UIButton!
    @IBOutlet weak var btnAutoConnectedOutStatus: UIButton!
    @IBOutlet weak var lblManualConnect: UILabel!
    @IBOutlet weak var txtFldManualConnectionIpAddress: UITextField!
    @IBOutlet weak var btnManualConnect: UIButton!
    @IBOutlet weak var btnManualReconnect: UIButton!
    @IBOutlet weak var btnManualConnectedInStatus: UIButton!
    @IBOutlet weak var btnManualConnectedOutStatus: UIButton!
    @IBOutlet weak var btnSendCrashReport: UIButton!
    
    @IBOutlet weak var vwBase: UIView!
    //MARK: Variables and Flags
    var hud = MBProgressHUD()
    var manualAddress = "0.0.0.0" //"192.168.0.238"
    var isConnected = false
    var seconds = 30
    var timer = Timer()
    var isTimerRunning = true
    //MARK: View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add drop shadow with corner radius
        self.vwBase.addShadowAllSide()
       // viewHideShow()
      self.loadingView.isHidden = true
        self.txtFldManualConnectionIpAddress.placeholder = ("ipaddress".localized).lowercased()
        self.txtFldManualConnectionIpAddress.keyboardType = .decimalPad
        self.txtFldManualConnectionIpAddress.delegate = self
        self.txtFldManualConnectionIpAddress.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        view.addGestureRecognizer(tap)
        
        let notif = NotificationCenter.default
        notif.addObserver(self, selector: #selector(self.updateConnectionUI(_:)), name: .socketConnectionStatusInContainer, object: nil)
        notif.addObserver(self, selector: #selector(self.updateUI(_:)), name: .uiUpdateContainerStartUp, object: nil)
        
        runTimer()
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600), execute: {
//            self.automaticLogin()
//        })
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateButtonSendCrashReport()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notif = NotificationCenter.default
        notif.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func updateTimer() -> Void {
        if seconds < 1 {
            isTimerRunning = false
            timer.invalidate()
            self.timerLabel.isHidden = true
            self.manualButton.isHidden = false
            //Send alert to indicate "time's up!"
        }else{
            seconds -= 1
            timerLabel.text = "\(seconds)"
            
        }
    }
    func runTimer() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(VCStartUp.updateTimer)), userInfo: nil, repeats: true)
    }
    func viewHideShow() {
        self.manualButton.isHidden = true
        self.timerLabel.isHidden = false
        if isConnected {
            self.loadingView.isHidden = true
            self.vwAutoConnect.isHidden = true
            self.autoLineView.isHidden = true
            self.vwManualConnect.isHidden = true
            self.manualLineView.isHidden = true
        }else{
            self.loadingView.isHidden = false
            self.vwAutoConnect.isHidden = true
            self.autoLineView.isHidden = true
            self.vwManualConnect.isHidden = true
            self.manualLineView.isHidden = true
        }
    }
     func automaticLogin()-> Void {
        guard !self.isConnected else {return;}
        hud = MBProgressHUD .showAdded(to: loadingView, animated: true)
        hud.mode = MBProgressHUDMode.determinateHorizontalBar
        hud.label.text = "Connecting..."
        self.hideKeyboard()
        var data : [String:Any] = [:]
        data["isAutoConnect"] = true
        NotificationCenter.default.post(name: .connect, object: nil, userInfo: data)
      }
    func onAutoReconnectting()-> Void {
        guard !self.isConnected else {return;}
        self.hideKeyboard()
        var data : [String:Any] = [:]
        data["isAutoConnect"] = true
        NotificationCenter.default.post(name: .reconnect, object: nil, userInfo: data)
    }
    func checkAutoConnectionStatus(completionHandler: CompletionHandler) {
        guard !self.isConnected else {return;}
        self.hideKeyboard()
        var data : [String:Any] = [:]
        data["isAutoConnect"] = true
        NotificationCenter.default.post(name: .connect, object: nil, userInfo: data)
        completionHandler(true)
    }
   
    //MARK: Auxillary Methods
    
    private func updateButtonSendCrashReport(){
        if let hasCrashReport = UserDefaults.standard.object(forKey: "hasCrashReport") as? Bool, hasCrashReport{
            self.btnSendCrashReport.isHidden  = false
        }else{
            self.btnSendCrashReport.isHidden = true
        }
    }
    
    //MARK: Update connection UI on notification received
    @objc func updateConnectionUI(_ notification: NSNotification){
        guard let userInfo = notification.userInfo else{return;}
        guard let status = userInfo["status"] as? Bool, let socketType = userInfo["socketType"] as? SocketType else {return}
        switch socketType{
        case .inSocket: //Incoming
            if let isAutoConnect = userInfo["isAutoConnect"] as? Bool, isAutoConnect{
                self.btnAutoConnectedInStatus.setImage((status ? #imageLiteral(resourceName: "wifi_connected") : #imageLiteral(resourceName: "wifi_disconnected") ), for: .normal)
            }else{
                self.btnManualConnectedInStatus.setImage((status ? #imageLiteral(resourceName: "wifi_connected") : #imageLiteral(resourceName: "wifi_disconnected") ), for: .normal)
            }
            guard status else{return;}
            self.disableAllUserInteractable()
            self.isConnected = true
        case .outSocket: // Outgoing
            if let isAutoConnect = userInfo["isAutoConnect"] as? Bool, isAutoConnect{
                self.btnAutoConnectedOutStatus.setImage((status ? #imageLiteral(resourceName: "wifi_connected") : #imageLiteral(resourceName: "wifi_disconnected") ), for: .normal)
            }else{
                self.btnManualConnectedOutStatus.setImage((status ? #imageLiteral(resourceName: "wifi_connected") : #imageLiteral(resourceName: "wifi_disconnected") ), for: .normal)
            }
        case .broadcast: // Incoming
            if let isAutoConnect = userInfo["isAutoConnect"] as? Bool, isAutoConnect{
                self.btnAutoConnectedInStatus.setImage((status ? #imageLiteral(resourceName: "wifi_connected") : #imageLiteral(resourceName: "wifi_disconnected") ), for: .normal)
            }else{
                self.btnManualConnectedInStatus.setImage((status ? #imageLiteral(resourceName: "wifi_connected") : #imageLiteral(resourceName: "wifi_disconnected") ), for: .normal)
            }
            guard status else{
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(90), execute: {
                    self.onAutoReconnectting()
                })
                return;
            }
            self.disableAllUserInteractable()
            self.isConnected = true
            hud.hide(animated: true)
            self.viewHideShow()
        }
    }
    
    @IBAction func manualSettingAction(_ sender: Any) {
    }
    @IBAction func onManualConnect(_ sender: UIButton) {
        guard !self.isConnected else {return;}
        self.hideKeyboard()
        guard self.validateIpAddress(ipAddress: self.manualAddress) else {
            self.showAlert(msg: "invalidipaddress".localized)
            return;
        }
        var data : [String:Any] = [:]
        data["isAutoConnect"] = false
        data["manualAddress"] = self.manualAddress
        NotificationCenter.default.post(name: .connect, object: nil, userInfo: data)
    }
    
    @IBAction func onManualReconnect(_ sender: UIButton) {
        guard !self.isConnected else {return;}
        self.hideKeyboard()
        guard self.validateIpAddress(ipAddress: self.manualAddress) else {
            self.showAlert(msg: "invalidipaddress".localized)
            return;
        }
        var data : [String:Any] = [:]
        data["isAutoConnect"] = false
        data["manualAddress"] = self.manualAddress
        NotificationCenter.default.post(name: .reconnect, object: nil, userInfo: data)
    }
    
    @IBAction func onAutoConnect(_ sender: UIButton) {
        guard !self.isConnected else {return;}
        self.hideKeyboard()
        var data : [String:Any] = [:]
        data["isAutoConnect"] = true
        NotificationCenter.default.post(name: .connect, object: nil, userInfo: data)
    }
    
    @IBAction func onAutoReconnect(_ sender: UIButton) {
        guard !self.isConnected else {return;}
        self.hideKeyboard()
        var data : [String:Any] = [:]
        data["isAutoConnect"] = true
        NotificationCenter.default.post(name: .reconnect, object: nil, userInfo: data)
    }
    
    @IBAction func onSendCrashReport(_ sender: UIButton) {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let fileURL = dir.appendingPathComponent(Globals.logFileName)
        let fileData = try? Data(contentsOf: fileURL)
        self.sendEmail(data:fileData)
    }
    
    //MARK: Update UI on notification received for container
    @objc func updateUI(_ notification: NSNotification) {
        //self.viewWillAppear(true)
    }
    
    //MARK: Disable all once connected
    private func disableAllUserInteractable(){
        self.txtFldManualConnectionIpAddress.isUserInteractionEnabled = false
    }
    
    //MARK: Validate IP address
    private func validateIpAddress(ipAddress: String) -> Bool {
        
//        // IPv6 peer
//        var sin6 = sockaddr_in6()
//        if ipAddress.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
//            return true
//        }
        
        // IPv4 peer
        var sin = sockaddr_in()
        if ipAddress.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
            guard ipAddress != "0.0.0.0" else {return false;}
            return true
        }
        
        return false;
    }
    
    //MARK: Show alert pop_up (common)
    private func showAlert(msg:String){
        self.presentAlertWithTitle(title:"ilinx".localized, message:msg, options:"ok".localized) { (option) in
            switch(option){
            case 0: break; //print("ok".localized)
            default: break;
            }
        }
    }
    
    //MARK: Hide Keyboard
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
}

extension VCStartUp: UITextFieldDelegate{
    
    //MARK: TextField methods
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if let text = textField.text{
            self.manualAddress = text
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
}

extension VCStartUp:MFMailComposeViewControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: Mail Compose methods
    
    func sendEmail(data:Data?){
        if( MFMailComposeViewController.canSendMail() ) {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setToRecipients(Globals.developersEmail)
            mailComposer.setSubject("crashreportsubject".localized)
            mailComposer.setMessageBody("crashreportbody".localized, isHTML: true)
            
            if let fileData = data {
                mailComposer.addAttachmentData(fileData, mimeType: "application/text", fileName: Globals.logFileName)
            }
            
            self.present(mailComposer, animated: true, completion: nil)
            return;
        }else{
            self.showAlert(msg: "mailnotconfigured".localized)
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        if let error = error{
            self.showAlert(msg: error.localizedDescription)
        }else{
            switch (result){
            case .cancelled, .failed, .saved: break;
            case .sent: // Update only if sent successfully
                UserDefaults.standard.set(false, forKey: "hasCrashReport")
                UserDefaults.standard.synchronize()
                
                self.updateButtonSendCrashReport()
                
                guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{break}
                let fileURL = dir.appendingPathComponent(Globals.logFileName)
                let text = ""
                try? text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
