//
//  App.swift
//  AppStore
//
//  Created by Damien Bivaud on 25/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

class AppDetails
{
    struct Rank
    {
        var category_id : String?
        var type : PriceType?
        var first_date : String?
        var last_date : String?
        var ranks : [Int]?
        
        mutating func parseFromJSON(json : [String:Any])
        {
            if let category_id = json["category_id"] as? String
            {
                self.category_id = category_id
            }
            if let type = json["type"] as? String, let priceType = PriceType(rawValue: type)
            {
                self.type = priceType
            }
            if let first_date = json["first_date"] as? String
            {
                self.first_date = first_date
            }
            if let last_date = json["last_date"] as? String
            {
                self.last_date = last_date
            }
            if let ranks = json["ranks"] as? [Int]
            {
                self.ranks = ranks
            }
        }
    }
    
    struct Developer
    {
        var name : String = ""
        var id : Int = 0
    }
    
    struct Screenshot
    {
        var id : String = ""
        var url : String = ""
        
        mutating func parseFromJSON(json : [String:Any])
        {
            if let id = json["id"] as? String
            {
                self.id = id
            }
            if let url = json["url"] as? String
            {
                self.url = url
            }
        }
    }
    
    struct Rating
    {
        var average : Double = 0.0
        var count : Int = 0
        var starCount : [String:Int] = [String:Int]()
        
        mutating func parseFromJSON(json : [String:Any])
        {
            var starCounts : [String:Int] = [String:Int]()
            if var starCount = json["star_count"] as? [String:Int]
            {
                for stars in starCount.keys
                {
                    starCounts[stars] = starCount[stars]
                }
            }
            self.average = json["average"] as! Double
            self.count = json["count"] as! Int
            self.starCount = starCounts
        }
    }
    
    struct StoreInfo
    {
        struct Version
        {
            var version : String?
            var release_date : String?
            var release_note : String?
        }
        
        enum Feature : String
        {
            case game_center    = "game_center"
            case passbook       = "passbook"
            case in_apps        = "in_apps"
        }
        
        var versions : [Version]?
        var icon : String?
        var genres : [Int]?
        var title : String?
        var slug : String?
        var description : String?
        var devices : [Device]?
        var price : String?
        var screenshots : [Device:[Screenshot]]?
        var release_date: String?
        var features: [Feature:Bool]?
        
        mutating func parseFromJSON(json : [String:Any])
        {
            if let versions = json["versions"] as? [Any]
            {
                self.versions = [Version]()
                for version in versions
                {
                    guard let aVersion = version as? [String:Any] else
                    {
                        return;
                    }
                    self.versions!.append(Version(version: aVersion["version"] as? String, release_date: aVersion["release_date"] as? String, release_note: aVersion["release_note"] as? String))
                }
            }
            if let icon = json["icon"] as? String
            {
                self.icon = icon
            }
            if let genres = json["genres"] as? [Int]
            {
                self.genres = genres
            }
            if let title = json["title"] as? String
            {
                self.title = title
            }
            if let slug = json["slug"] as? String
            {
                self.slug = slug
            }
            if let description = json["description"] as? String
            {
                self.description = description
            }
            if let devices = json["devices"] as? [String]
            {
                self.devices = [Device]()
                for dev in devices
                {
                    if let device = Device(rawValue: dev)
                    {
                        self.devices!.append(device)
                    }
                }
            }
            if let price = json["price"] as? String
            {
                self.price = price
            }
            if let screenshots = json["screenshots"] as? [String:Any]
            {
                self.screenshots = [Device:[Screenshot]]()
                for deviceType in screenshots.keys
                {
                    if let screenshotsByDevice = screenshots[deviceType] as? [[String:Any]], let device = Device(rawValue: deviceType)
                    {
                        if self.screenshots?[device] == nil
                        {
                            self.screenshots![device] = [Screenshot]()
                        }
                        for screen in screenshotsByDevice
                        {
                            var screenshot = Screenshot()
                            screenshot.parseFromJSON(json: screen)
                            self.screenshots![device]?.append(screenshot)
                        }
                    }
                }
            }
            if let features = json["features"] as? [String:Any]
            {
                self.features = [Feature:Bool]()
                if let game_center = features["game_center"] as? Bool
                {
                    self.features![Feature.game_center] = game_center
                }
                else
                {
                    self.features![Feature.game_center] = false
                }
                if let passbook = features["passbook"] as? Bool
                {
                    self.features![Feature.passbook] = passbook
                }
                else
                {
                    self.features![Feature.passbook] = false
                }
                if let in_apps = features["in_apps"] as? Bool
                {
                    self.features![Feature.in_apps] = in_apps
                }
                else
                {
                    self.features![Feature.in_apps] = false
                }
            }
        }
    }
    
    var application_id : Int?
    var ranks : [Rank]?
    var developer : Developer?
    var storeInfo : StoreInfo?
    var current_rating : Rating?
    var all_rating : Rating?
    var country_code : String?
    var langage : String?
    
    init() {
    }
    
    func populate(_ json: [String:Any])
    {
        if let application_id = json["application_id"] as? Int
        {
            self.application_id = application_id;
        }
        if let ranks = json["rankings"] as? [Any]
        {
            for rank in ranks
            {
                var aRank = Rank()
                aRank.parseFromJSON(json: rank as! [String:Any])
                self.ranks?.append(aRank)
            }
        }
        if let developer = json["developer"] as? [String:Any]
        {
            self.developer = Developer(name: developer["name"] as! String, id: developer["id"] as! Int);
        }
        if let store_info = json["store_info"] as? [String:Any]
        {
            self.storeInfo = StoreInfo()
            self.storeInfo?.parseFromJSON(json: store_info)
        }
        if let ratings = json["ratings"] as? [String:Any]
        {
            if let current_rating = ratings["current_version"] as? [String:Any]
            {
                self.current_rating = Rating()
                self.current_rating!.parseFromJSON(json: current_rating)
            }
            if let all_rating = ratings["all_versions"] as? [String:Any]
            {
                self.all_rating = Rating()
                self.all_rating!.parseFromJSON(json: all_rating)
            }
        }
        if let country_code = json["country_code"] as? String
        {
            self.country_code = country_code
        }
        if let langage = json["langage"] as? String
        {
            self.langage = langage
        }
    }
    
    func getFirstAvailableScreenShot() -> Screenshot?
    {
        if let info = self.storeInfo, let screenshots = info.screenshots
        {
            for screens in screenshots.values
            {
                if !screens.isEmpty
                {
                    return screens[0]
                }
            }
        }
        return nil
    }
    
    func getAvailableScreenshotsByType(device: String) -> [Screenshot]?
    {
        var screenshots : [Screenshot]? = nil
        Device.allCases.forEach{ aDevice in
            if aDevice.rawValue.contains(device), let empty = storeInfo?.screenshots?[aDevice]?.isEmpty, !empty
            {
                screenshots = storeInfo!.screenshots![aDevice]!
            }
        }
        return screenshots
    }
}
