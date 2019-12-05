//
//  PopUp.swift
//  iLinX
//
//  Created by Vikas Ninawe on 23/10/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//  Purpose: This is used to show pop-up which includes open url in browser, ...

import UIKit

public class PopUp{

    // Open URL in browser
    func openURLInBrowser(urlStr:String){
        var link = urlStr
        if((link.range(of: "http://", options:.caseInsensitive) != nil) || (link.range(of: "https://", options:.caseInsensitive) != nil)){
            link = urlStr
        }else{
            link = "http://" + link
        }
        
        if #available(iOS 10.0, *){
           UIApplication.shared.open(URL(string:link)!, options: [:], completionHandler: nil)
        }else{
            UIApplication.shared.openURL(URL(string:link)!)
        }
    }
}
