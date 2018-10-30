//
//  AppInfo.swift
//  AppStore
//
//  Created by Damien Bivaud on 30/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

class AppInfo
{
    var application_id : Int?
    var title : String?
    var icon : String?
    var developer : String?
    var price : String?
    var genres : [Int]?
    var devices : [String]?
    var slug : String?
    
    init() {
    }
    
    func populateFromJSON(_ json: [String:Any])
    {
        if let slug = json["slug"] as? String
        {
            self.slug = slug
        }
        if let icon = json["icon"] as? String
        {
            self.icon = icon;
        }
        if let price = json["price"] as? String
        {
            self.price = price;
        }
        if let genres = json["genres"] as? [Int]
        {
            self.genres = genres
        }
        if let application_id = json["id"] as? Int
        {
            self.application_id = application_id;
        }
        if let devices = json["devices"] as? [String]
        {
            self.devices = devices
        }
        if let developer = json["developer"] as? String
        {
            self.developer = developer
        }
        if let title = json["title"] as? String
        {
            self.title = title;
        }
    }
}


