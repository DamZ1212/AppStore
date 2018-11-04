//
//  AppCommonData.swift
//  AppStore
//
//  Created by Damien Bivaud on 04/11/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

enum PriceType : String
{
    case free = "free"
    case paid = "paid"
    case grossing = "grossing"
}

enum Device : String, CaseIterable
{
    case ipad           = "ipad"
    case ipod           = "ipod"
    case iphone         = "iphone"
    case iphone5        = "iphone5"
    case iphone6        = "iphone6"
    case iphone6plus    = "iphone6plus"
}
