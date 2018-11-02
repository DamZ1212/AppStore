//
//  NewGamesService.swift
//  AppStore
//
//  Created by Damien Bivaud on 02/11/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

class NewGamesService
{
    var requester : AppTweakRequester
    
    init() {
        requester = AppTweakRequester()
    }
    
    func getNewGames(amount : Int, _ callback:@escaping ([AppInfo]?) -> Void) {
        let gamesRequest = TopAppsRequest(category: Category.games.rawValue, amount: amount)
        requester.query(req: gamesRequest, completion: {data, response, error in
            var games : [AppInfo]?
            guard let data = data, error == nil else
            {
                callback(games)
                return
            }
            print("New Games Service: " + String(data: data, encoding: .utf8)!)
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            {
                games = [AppInfo]()
                for gameData in json!["content"] as! [Any]
                {
                    let app = AppInfo()
                    app.populateFromJSON(gameData as! [String : Any])
                    games!.append(app)
                }
            }
            callback(games)
        })
    }
}
