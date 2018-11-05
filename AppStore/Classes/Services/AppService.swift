//
//  AppService.swift
//  AppStore
//
//  Created by Damien Bivaud on 29/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

class AppService
{
    var apps : [Int:AppDetails]
    var requester : AppTweakRequester
    
    init() {
        requester = AppTweakRequester()
        apps = [Int:AppDetails]()
    }
    
    func getAppData(appId: Int, _ callback:@escaping (AppDetails) -> Void) {
        if let app = apps[appId]
        {
            DispatchQueue.main.async {callback(app)}
        }
        else
        {
            let appRequest = AppDataRequest(id: appId)
            requester.query(req: appRequest, completion: {data, response, error in
                do
                {
                    let appDetails : AppDetails? = try self.parseAppData(data: data!)
                    DispatchQueue.main.async {callback(appDetails!)}
                }
                catch
                {
                    let json = String(data: data!, encoding: .utf8)
                    print("json : \(json)")
                    print(error)
                }
            })
        }
    }
    
    func parseAppData(data : Data) throws -> AppDetails?
    {
        do
        {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            {
                if let content = json["content"] as? [String:Any]
                {
                    let appDetails = AppDetails()
                    appDetails.populate(content)
                    return appDetails
                }
            }
        }
        catch
        {
            throw(error)
        }
        return nil
    }
}
