//
//  ExtArray.swift
//  iLinX
//
//  Created by Vikas Ninawe on 12/12/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
