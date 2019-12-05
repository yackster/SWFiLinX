//
//  VCLog.swift
//  iLinX
//
//  Created by Vikas Ninawe on 18/01/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//

import UIKit

class VCLog: UIViewController {

    @IBOutlet weak var btnPrint: UIButton!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tblVwLog: UITableView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var vwTop: UIView!
    
    var arrLog = [LogData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVwLog.delegate = self
        self.tblVwLog.dataSource = self
        self.tblVwLog.estimatedRowHeight = 60
        self.tblVwLog.rowHeight = UITableView.automaticDimension
        self.lblHeading.text = "log".localized
        self.vwTop.addShadowBottom()
        
        let notif = NotificationCenter.default
        notif.addObserver(self, selector: #selector(self.updateLog(_:)), name: .uiUpdateLog, object: nil)
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPrint(_ sender: UIButton) {
        guard self.arrLog.count > 0 else {return;}
        self.presentAlertWithTitle(title:"ilinx".localized, message:"wantToPrintLog".localized, options:"yes".localized, "no".localized) { (option) in
            switch(option){
            case 0: self.printLogToPDF(self.tblVwLog) //YES
            case 1: break; // NO
            default: break;
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.arrLog = ModelHome.arrLog.reversed()
        self.tblVwLog.reloadData()
    }
    
    @objc func updateLog(_ notification: NSNotification){
        self.arrLog = ModelHome.arrLog.reversed()
        self.tblVwLog.reloadData()
    }

}

extension VCLog: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrLog.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell
        cell.setValues(values: arrLog[indexPath.row])
        cell.selectionStyle = .none
        return cell;
    }
    
    func printLogToPDF(_ tableView: UITableView){
    
        self.showHUD(progressLabel: "creatingAndLoading".localized)
        //Creating
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            guard let pdfData = self.tblVwLog.convertToPDF() else{
                self.hideHUD(isAnimated: true)
                return;
            }
            var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            docURL = docURL.appendingPathComponent(Globals.responseLogFileName)
            do{
                try pdfData.write(to: docURL as URL)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    var path = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                    path = path.appendingPathComponent(Globals.responseLogFileName) as URL
                    let dc = UIDocumentInteractionController(url: path)
                    dc.delegate = self
                    dc.presentPreview(animated: true)
                })
            }catch let error{
                self.hideHUD(isAnimated: true)
                self.presentAlertWithTitle(title:"ilinx".localized, message: error.localizedDescription, options:"ok".localized){ (option) in
                    switch(option){
                    case 0: break; //print("ok".localized)
                    default: break;
                    }
                }
            }
        })
    }
}

extension VCLog: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        //print("documentInteractionControllerDidEndPreview") // on close pdf
    }
    func documentInteractionControllerWillBeginPreview(_ controller: UIDocumentInteractionController) {
        //print("documentInteractionControllerWillBeginPreview") // on pdf loading done
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500), execute: {
            self.hideHUD(isAnimated: true)
        })
    }
}


