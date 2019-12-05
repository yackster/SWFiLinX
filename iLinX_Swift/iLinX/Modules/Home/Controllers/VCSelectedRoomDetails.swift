//
//  VCSelectedRoomDetails.swift
//  iLinX
//
//  Created by Vikas Ninawe on 30/11/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

class VCSelectedRoomDetails: UIViewController {
    
    @IBOutlet weak var vwBase: UIView!
    
    //MARK: View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add dropshadow with corner
        self.vwBase.addShadowAllSide()
        
        let notif = NotificationCenter.default
        notif.addObserver(self, selector: #selector(self.updateUI(_:)), name: .uiUpdateContainerSelectedRoomDetails, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notif = NotificationCenter.default
        notif.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Auxillary Methods
    
    //MARK: Update UI on notification received for container
    @objc func updateUI(_ notification: NSNotification) {
        //self.viewWillAppear(true)
    }

}
