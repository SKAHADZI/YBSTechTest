//
//  FileStoreManager.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 29/08/2024.
//

import Foundation
import os
import UIKit

final class FileStoreManager {
    
    public static let shared = FileStoreManager()
    private let fileManager = FileManager.default
    private let logger = Logger(subsystem: "com.SenSen.YBSTechTest", category: "networking")
    private init() {}
    
    func addToDisk(image: UIImage, for key: String) {
        guard let cacheFolder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        
        let fileUrl = cacheFolder.appending(path: key, directoryHint: .isDirectory)
        
        do {
            let data = image.jpegData(compressionQuality: 0.7)
            
            try data?.write(to: fileUrl)
        } catch {
            logger.error("failed to save to disk")
        }
    }
    
    func retrieveFromDisk(for key: String) -> UIImage? {
        guard let cacheFolder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let fileUrl = cacheFolder.appendingPathComponent(key)
        
        guard fileManager.fileExists(atPath: fileUrl.path) else {
            logger.info("No disk image found at: \(fileUrl.path, privacy: .public)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data)
        } catch {
            logger.error("Failed to retrieve image from disk")
            return nil
        }
    }
    
    // To be used for cache eviction policies when written
    func removeFromDisk(for key: String) {
        guard let cacheFolder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        
        let fileUrl = cacheFolder.appendingPathComponent(key)
        
        if fileManager.fileExists(atPath: fileUrl.path) {
            do {
                try fileManager.removeItem(at: fileUrl)
                logger.info("File removed successfully at: \(fileUrl.path)")
            } catch {
                logger.error("Failed to remove file: \(error.localizedDescription)")
            }
        } else {
            logger.info("No file exists at: \(fileUrl.path)")
        }
    }
}
