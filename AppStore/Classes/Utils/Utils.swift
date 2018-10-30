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

func getImage(from url: URL, to container: UIImageView?) {
    getDataFromURL(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async() {
            if (container != nil)
            {
                container!.image = UIImage(data: data)
            }
        }
    }
}

