//
//  Utils.swift
//  AppStore
//
//  Created by Damien Bivaud on 28/10/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation
import UIKit

// Retrieving data from URL
func getDataFromURL(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

func getImage(from url: URL, callback: @escaping ((UIImage?) -> Void) = { image in return }) {
    getDataFromURL(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async() {
            callback(UIImage(data: data))
        }
    }
}

func getDeviceModelType() -> String
{
    let model = UIDevice.current.model
    return model.lowercased()
}

func getAppStoreAppURL(country : String, name : String, id : String) -> String
{
    return String("http://itunes.apple.com/\(country.lowercased())/app/\(name)/id\(id)?mt=8")
}

