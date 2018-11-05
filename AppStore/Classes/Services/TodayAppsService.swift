//
//  AppService.swift
//  AppStore
//
//  Created by Damien Bivaud on 25/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

class TodayAppsService
{
    var requester : AppTweakRequester
    var appsOfTheDay : [Int:AppInfo]
    
    init() {
        appsOfTheDay = [Int:AppInfo]()
        requester = AppTweakRequester()
    }
    
    func getAppsOfTheDay(_ callback:@escaping () -> Void) {
        let topAppsRequest = TopAppsRequest(category: Category.all.rawValue)
        requester.query(req: topAppsRequest, completion: {data, response, error in
            do
            {
                try self.parseAppsOfTheDayData(data: data!)
            }
            catch
            {
                print(error)
            }
            DispatchQueue.main.async {callback()}
        })
    }
    
    func parseAppsOfTheDayData(data : Data) throws
    {
        do
        {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            {
                self.appsOfTheDay = [Int:AppInfo]()
                for appData in json["content"] as! [Any]
                {
                    let app = AppInfo()
                    app.populateFromJSON(appData as! [String : Any])
                    if let id = app.application_id
                    {
                        self.appsOfTheDay[id] = app
                    }
                }
            }
        }
        catch
        {
            throw(error)
        }
    }
    
    func getGameOfTheDay() -> AppInfo?
    {
        if let result = appsOfTheDay.first(where: { pair -> Bool in
            return (pair.value.genres?.contains
            {
                element in
                if element == Category.games.rawValue
                {
                    return true
                }
                return false
            })!
        })
        {
            return result.value
        }
        return nil
    }
    
    func getAppOfTheDay() -> AppInfo? {
        if let result = appsOfTheDay.first(where: { pair -> Bool in
            return !(pair.value.genres?.contains
            {
                element in
                if element == Category.games.rawValue
                {
                    return true
                }
                return false
            })!
        })
        {
            return result.value
        }
        return nil
    }
}
