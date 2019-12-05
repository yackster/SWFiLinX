//
//  VCAudioVideoSource.swift
//  iLinX
//
//  Created by Vikas Ninawe on 30/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

class VCAudioVideoSource: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var vwPopUp: UIView!
    @IBOutlet weak var btnCloseCorner: UIButton!
    @IBOutlet weak var collectionVwFavourites: UICollectionView!
    @IBOutlet weak var lblNoData: UILabel!
    
    @IBOutlet weak var vwFavouritesList: UIView!
    
    var popDelegate:PopOver?
    var info:ComposedType?
    
    //MARK: View Controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblNoData.text = "noFavouriteAvail".localized
        
        //Set collectionview delegate and datasource
        self.collectionVwFavourites.delegate = self
        self.collectionVwFavourites.dataSource = self
        
        self.vwPopUp.layer.cornerRadius = 5.0
        self.vwPopUp.clipsToBounds = true
        //self.btnCloseCorner.setTitle("close".localized, for: .normal)
        
        let notif = NotificationCenter.default
        notif.addObserver(self, selector: #selector(self.updateUI(_:)), name: .uiUpdateContainerAudioVideoSource, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let rmIdx = SelectedItemDetails.roomIndex
        print("RmIdx is \(rmIdx)")
        print("Favourities \(ModelHome.availableRooms[rmIdx].favourites)")
        if (rmIdx >= 0) && ModelHome.availableRooms[rmIdx].favourites.count > 0{
            self.lblNoData.isHidden = true
        }else{
           self.lblNoData.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notif = NotificationCenter.default
        notif.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Update UI on notification received for container
    @objc func updateUI(_ notification: NSNotification) {
        //self.viewWillAppear(true)
    }
    
    //MARK: IBActions
    
    @IBAction func onClose(_ sender: UIButton) {
        self.popDelegate?.onPop(info:self.info)
        self.dismiss(animated: true, completion: nil)
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
}

extension VCAudioVideoSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //let rmIdx = SelectedItemDetails.roomIndex
        //return (rmIdx >= 0) ? ModelHome.availableRooms[rmIdx].favourites.count : 0
        return 3;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rmIdx = SelectedItemDetails.roomIndex
        let cellFavouriteCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFavouriteCollectionView", for: indexPath) as! CellFavouriteCollectionView
        cellFavouriteCollectionView.setValues(values: ModelHome.availableRooms[rmIdx].favourites[indexPath.item])
        cellFavouriteCollectionView.btnFavourite.addTarget(self, action: #selector(self.onFavouriteSelect(_:)), for: .touchUpInside)
        cellFavouriteCollectionView.btnFavourite.accessibilityValue = ModelHome.availableRooms[rmIdx].favourites[indexPath.item].macro
        return cellFavouriteCollectionView;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frm = self.collectionVwFavourites.frame
        return CGSize(width:frm.width*0.5 - 5, height:frm.height*0.15);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @objc func onFavouriteSelect(_ sender:UIButton){
        
        guard (SelectedItemDetails.roomIndex > -1) else {return;} // Room must be selected
        guard SelectedItemDetails.inputSourceIndex > -1 else { // Source must be selected
            self.showAlert(msg: "selectinputsourcefirst".localized)
            return
        }
        
        guard let macro = sender.accessibilityValue else{return;}
        
        SelectedItemDetails.elementType = .favourite
        var data : [String:Any] = [:]
        data["favourite"] = macro
        NotificationCenter.default.post(name: .socketCallFromContainer, object: nil, userInfo: data)
    }
    
}
