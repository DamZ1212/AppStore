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
    
    func getNewGames(amount : Int, _ callback:@escaping ([AppInfo]?, Int) -> Void) {
        let gamesRequest = TopAppsRequest(category: Category.games.rawValue, amount: amount)
        requester.query(req: gamesRequest, completion: {data, response, error in
            var games : [AppInfo]?
            do
            {
                games = try self.parseNewGamesData(amount : amount, data : data!)
            }
            catch
            {
                print(error)
            }
            DispatchQueue.main.async {callback(games, amount)}
        })
    }
    
    func parseNewGamesData(amount : Int, data : Data) throws -> [AppInfo]?
    {
        do
        {
            var games : [AppInfo]?
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            {
                games = [AppInfo]()
                for gameData in json["content"] as! [Any]
                {
                    guard games!.count < amount
                        else
                    {
                        return games
                    }
                    let app = AppInfo()
                    app.populateFromJSON(gameData as! [String : Any])
                    games!.append(app)
                }
            }
            return games
        }
        catch
        {
            throw(error)
        }
    }
}
