//
//  AppCommonData.swift
//  AppStore
//
//  Created by Damien Bivaud on 04/11/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

/**
 Common data types accross all app tweak requests
 */

// app price type
enum PriceType : String
{
    case free = "free"
    case paid = "paid"
    case grossing = "grossing"
}

// Device type according to app tweak
enum Device : String, CaseIterable
{
    case ipad           = "ipad"
    case ipod           = "ipod"
    case iphone         = "iphone"
    case iphone5        = "iphone5"
    case iphone6        = "iphone6"
    case iphone6plus    = "iphone6plus"
}

// App catgeries
enum Category : Int
{
    case all = 0
    case books = 6018
    case business = 6000
    case catalogs = 6022
    case education = 6017
    case entertainment = 6016
    case finance = 6015
    case food_and_drink = 6023
    case games = 6014
    case health_and_Fitness = 6013
    case lifestyle = 6012
    case medical = 6020
    case music = 6011
    case navigation = 6010
    case news = 6009
    case newsstand = 6021
    case photo_and_video = 6008
    case productivity = 6007
    case reference = 6006
    case social_networking = 6005
    case shopping = 6024
    case sports = 6004
    case travel = 6003
    case utilities = 6002
    case weather = 6001
    case game_action = 7001
    case game_adventure = 7002
    case game_arcade = 7003
    case game_board = 7004
    case game_card = 7005
    case game_casino = 7006
    case game_dice = 7007
    case game_educational = 7008
    case game_family = 7009
    case game_kids = 7010
    case game_music = 7011
    case game_puzzle = 7012
    case game_racing = 7013
    case game_role_playing = 7014
    case game_simulation = 7015
    case game_sports = 7016
    case game_strategy = 7017
    case game_trivia = 7018
    case game_word = 7019
}

