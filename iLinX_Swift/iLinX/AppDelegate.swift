//
//  AppDelegate.swift
//  iLinX
//
//  Created by Vikas Ninawe on 23/10/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //self.writeLogToDocument()
        //Print sandbox path for current project
        //let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        //print("AppDelegate - Sandbox Path for iLinX: \(String(describing: documentsUrl))")        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //self.appendStackTraceToDocument(from:"applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let notif = NotificationCenter.default
        notif.post(name: .stopWhileSuspended, object: nil, userInfo: nil)
       // OutSocket.sharedOutSocket.socket.closeAfterSending()
        //BroadcastSocket.sharedBroadcastSocket.socket.closeAfterSending()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.        
        ModelHome.connectWhileSuspended = true
        let notif = NotificationCenter.default
        notif.post(name: .connectWhileSuspended, object: nil, userInfo: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //self.appendStackTraceToDocument(from: "applicationWillTerminate")
    }
    
    private func writeLogToDocument() {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        let pathForLog: String = documentsDirectory.appendingFormat("/" + Globals.logFileName)
        freopen(pathForLog.cString(using: String.Encoding.ascii)!, "a+", stderr)
    }
    
    private func appendStackTraceToDocument(from:String){
        var str = ""
        guard Thread.callStackSymbols.count > 0 else{return;}
        UserDefaults.standard.set(true, forKey: "hasCrashReport")
        UserDefaults.standard.synchronize()
        str = str + "\n" + from        
        for i in Thread.callStackSymbols{
            str = str + "\n" + i
        }
        let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
        let url = dir.appendingPathComponent(Globals.logFileName)
        try? "\(str)".appendLineToURL(fileURL: url as URL)
    }

}




