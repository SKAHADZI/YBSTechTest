//
//  APIKey.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import Foundation

struct APIKey {
    static var apiKey: String {
        get {
            // Get path from bundle
            guard let filePath = Bundle.main.path(forResource: "Flickr-Photo", ofType: "Plist") else {
              fatalError("Couldn't find file 'Flickr-Photo.plist'.")
            }
            // Get value from path
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
              fatalError("Couldn't find key 'API_KEY' in 'Flickr-Photo.plist'.")
            }
            return value
          }
    }
}
