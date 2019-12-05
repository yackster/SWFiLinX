//
//  ExtUIViewController.swift
//  iLinX
//
//  Created by Vikas Ninawe on 12/12/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    
    // Show activity indicator
    func showHUD(progressLabel:String){
        self.hideHUD(isAnimated: true)
        //let appDel = UIApplication.shared.delegate as! AppDelegate
        //let progressHUD = MBProgressHUD.showAdded(to: (appDel.window?.rootViewController?.view)!, animated: true)
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = progressLabel
    }
    
    // Hide activity indicator
    func hideHUD(isAnimated:Bool) {
        //let appDel = UIApplication.shared.delegate as! AppDelegate
        //MBProgressHUD.hide(for: (appDel.window?.rootViewController?.view)!, animated: isAnimated)
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: isAnimated)
        }        
    }
}
