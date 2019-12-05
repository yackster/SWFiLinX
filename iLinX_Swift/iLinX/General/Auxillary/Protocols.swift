//
//  Protocols.swift
//  iLinX
//
//  Created by Vikas Ninawe on 26/02/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//

import Foundation

typealias ComposedType = (Element, SelectedItemDetails.SelectedType)

protocol PopOver {
    func onPop(info:ComposedType?)
}
