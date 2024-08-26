//
//  CachingService.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import Foundation
import SwiftUI

protocol CachingService {
    func getCachedImage(for key: String) -> UIImage?
    func removeCachedImage(for key: String)
    func cacheImage(_ image: UIImage, for key: String)
    func clearCache()
}

final class CachingServiceImpl: CachingService {
    
    let cache = NSCache<NSString, UIImage>()
    
    func getCachedImage(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func removeCachedImage(for key: String) {
        return cache.removeObject(forKey: key as NSString)
    }
    
    func cacheImage(_ image: UIImage, for key: String) {
        return cache.setObject(image, forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
