//
//  AppTweakRequest.swift
//  AppStore
//
//  Created by Damien Bivaud on 28/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

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

protocol Request
{
    func getURL() -> URL?
}

class AppTweakRequest
{
    var country : String = "fr"
    var langage : String = "fr"
    var device : String = "iphone"
}

class TopAppsRequest : AppTweakRequest, Request
{
    var category : Int = Category.all.rawValue
    var type : String = "free"
    
    init(category : Int) {
        self.category = category
    }
    
    func getURL() -> URL?
    {
        var url = AppTweakRequester.baseURL
        url += "categories/\(self.category)/top.json?country=\(self.country)&langage=\(self.langage)&device=\(self.device)&type=\(self.type)"
        return URL(string: url)
    }
}

class AppDataRequest : AppTweakRequest, Request
{
    var id : Int = 0
    
    init(id : Int) {
        self.id = id
    }
    
    func getURL() -> URL?
    {
        var url = AppTweakRequester.baseURL
        url += "applications/\(id).json?country=\(country)&langage=\(langage)&device=\(device)"
        return URL(string: url)
    }
}

class SearchAppsRequest : AppTweakRequest, Request
{
    var term : String = ""
    
    init(term : String) {
        self.term = term
    }
    
    func getURL() -> URL?
    {
        var url = AppTweakRequester.baseURL
        url += "searches.json?term=\(term)&country=\(country)&langage=\(langage)&device=\(device)"
        return URL(string: url)
    }
}

class AppTweakRequester
{
    static var secretKey : String = "WiZjajvanUYJu2Gk6g79piE41Y4"
    static var baseURL : String = "https://api.apptweak.com/ios/"
    
    func query(req: Request, completion: @escaping (Data?, URLResponse?, Error?) -> ())
    {
        if let url = req.getURL()
        {
            var request = URLRequest(url: url)
            request.setValue(AppTweakRequester.secretKey, forHTTPHeaderField: "X-Apptweak-Key")
            let query = URLSession.shared.dataTask(with: request, completionHandler: completion)
            query.resume()
        }
    }
}
