//
//  AppTweakRequest.swift
//  AppStore
//
//  Created by Damien Bivaud on 28/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

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

// Get top apps by parameters
class TopAppsRequest : AppTweakRequest, Request
{
    var category : Int = Category.all.rawValue
    var amount : Int
    var priceType : PriceType = .free
    
    init(category : Int, amount : Int = 10, priceType : PriceType = .free) {
        self.category = category
        self.amount = amount
        self.priceType = priceType
    }
    
    func getURL() -> URL?
    {
        var url = GlobalConstants.AppTweak.BaseURL
        url += "categories/\(self.category)/top.json?country=\(self.country)&langage=\(self.langage)&device=\(self.device)&type=\(self.priceType.rawValue)&num=\(amount)"
        return URL(string: url)
    }
}

// Get targeted app data
class AppDataRequest : AppTweakRequest, Request
{
    var id : Int = 0
    
    init(id : Int) {
        self.id = id
    }
    
    func getURL() -> URL?
    {
        var url = GlobalConstants.AppTweak.BaseURL
        url += "applications/\(id).json?country=\(country)&langage=\(langage)&device=\(device)"
        return URL(string: url)
    }
}

// Get apps by search term
class SearchAppsRequest : AppTweakRequest, Request
{
    var term : String = ""
    
    init(term : String) {
        self.term = term
    }
    
    func getURL() -> URL?
    {
        var url = GlobalConstants.AppTweak.BaseURL
        url += "searches.json?term=\(term)&country=\(country)&langage=\(langage)&device=\(device)"
        return URL(string: url)
    }
}

// Basic requester
class AppTweakRequester
{
    func query(req: Request, completion: @escaping (Data?, URLResponse?, Error?) -> ())
    {
        if let url = req.getURL()
        {
            var request = URLRequest(url: url)
            request.setValue(GlobalConstants.AppTweak.SecretKey, forHTTPHeaderField: GlobalConstants.AppTweak.HeaderKey)
            let query = URLSession.shared.dataTask(with: request, completionHandler: completion)
            query.resume()
        }
    }
}
