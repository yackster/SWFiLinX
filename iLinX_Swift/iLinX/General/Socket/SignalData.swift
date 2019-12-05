//
//  SignalData.swift
//  iLinX
//
//  Created by Vikas Ninawe on 03/08/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//

import Foundation
struct Signal {
    var firstSignal:UInt16 = 20
    var secondSignal:UInt16 = 30
    var thirdSignal: UInt16  = 40
    var fourthSignal: UInt16 = 50
    static func archive(w:Signal) -> Data {
        var fw = w
        return Data(bytes: &fw, count: MemoryLayout<Signal>.stride)
    }
    static func unarchive(d:Data) -> Signal {
        guard d.count == MemoryLayout<Signal>.stride else {
            fatalError("BOOM!")
        }
        var s:Signal?
        d.withUnsafeBytes({(bytes: UnsafePointer<Signal>)->Void in
            s = UnsafePointer<Signal>(bytes).pointee
        })
        return s!
    }
}
