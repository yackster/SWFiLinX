//
//  Log.swift
//  iLinX
//
//  Created by Vikas Ninawe on 23/10/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//  Purpose: This is used to print log that can be disabled easily.

import Foundation

class Log{
    
    class var isEnable:Bool {return true}  //  true - to display all the print messages in terminal - debug
    
    class func show(args:AnyObject...){
        if(isEnable){
            //print("Start","-----------------",Thread.callStackSymbols[2])
            for arg: AnyObject in args{
                print(arg)
            }
            //print("-----------------","End")
        }
    }
}
