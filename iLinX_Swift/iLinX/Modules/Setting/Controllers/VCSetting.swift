//
//  VCSetting.swift
//  iLinX
//
//  Created by Vikas Ninawe on 30/10/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.


import UIKit

class VCSetting: UIViewController {

    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblVwSetting: UITableView!
    @IBOutlet weak var vwTop: UIView!
    
    @IBOutlet weak var vwSettingList: UIView!
    
    var ipAddress = ""
    var connectionStatusType =  ""
    var arrHeading = [Heading]()
    var selectedHeader = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add dropshadow with corner
        self.vwSettingList.addShadowAllSide()
        
        self.tblVwSetting.delegate = self
        self.tblVwSetting.dataSource = self
        self.tblVwSetting.estimatedRowHeight = 50
        self.tblVwSetting.rowHeight = UITableView.automaticDimension
        self.tblVwSetting.estimatedSectionHeaderHeight = 50
        self.tblVwSetting.sectionHeaderHeight = UITableView.automaticDimension
        self.lblHeading.text = "setting".localized
        self.vwTop.addShadowBottom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let decoder = DictionaryDecoder()
        for dict in ModelSetting.settingData{
            if let decoded = try? decoder.decode(Heading.self, from: dict){
                self.arrHeading.append(decoded)
            }
        }
        self.tblVwSetting.reloadData()

        //fatalError("App crashed forcefully!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension VCSetting: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrHeading.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedHeader == section{
            return self.arrHeading[section].details?.count ?? 0
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension;
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingDetailCell", for: indexPath) as! SettingDetailCell
        let info = self.arrHeading[indexPath.section].details?[indexPath.row].info ?? ""
        cell.lblDetailInfo.text = "\(info)"
        cell.selectionStyle = .none
        return cell;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingHeadingCell") as! SettingHeadingCell
        var heading = self.arrHeading[section].heading ?? ""
        if section == 0{
            heading = "\(heading) \(self.ipAddress) \((self.ipAddress == "") ? "" : (", " + self.connectionStatusType))"
        }
        cell.lblHeading.text = heading
        cell.btnHeading.addTarget(self, action: #selector(self.onDropDown(_:)), for: .touchUpInside)
        cell.btnHeading.tag = section
        cell.selectionStyle = .none
        return cell;
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView();
    }
    
    
    @objc func onDropDown(_ sender:UIButton){
        self.selectedHeader = sender.tag
        self.tblVwSetting.reloadData()
    }
}
