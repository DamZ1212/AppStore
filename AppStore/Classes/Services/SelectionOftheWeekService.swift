//
//  SelectionOftheWeekService.swift
//  AppStore
//
//  Created by Damien Bivaud on 04/11/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

class SelectionOfTheWeekService
{
    var requester : AppTweakRequester
    
    init() {
        requester = AppTweakRequester()
    }
    
    func getSelectedAppsOfTheWeek(amount : Int, type : PriceType, _ callback:@escaping ([AppInfo]?, Int) -> Void) {
        let gamesRequest = TopAppsRequest(category: Category.games.rawValue, amount: amount, priceType: type)
        requester.query(req: gamesRequest, completion: {data, response, error in
            var apps : [AppInfo]?
            do
            {
                apps = try self.parseSelectionOfAppsOfTheWeek(amount: amount, data: data!)
            }
            catch
            {
                print(error)
            }
            DispatchQueue.main.async {callback(apps, amount)}
        })
    }
    
    func parseSelectionOfAppsOfTheWeek(amount : Int, data : Data) throws -> [AppInfo]?
    {
        do
        {
            var apps : [AppInfo]?
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            {
                apps = [AppInfo]()
                for appData in json["content"] as! [Any]
                {
                    guard apps!.count < amount
                        else
                    {
                        return apps
                    }
                    let app = AppInfo()
                    app.populateFromJSON(appData as! [String : Any])
                    apps!.append(app)
                }
            }
            return apps
        }
        catch
        {
            throw(error)
        }
    }
}
