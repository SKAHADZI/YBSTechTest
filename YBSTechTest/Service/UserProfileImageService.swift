//
//  UserProfileImageService.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import Combine
import Foundation
import UIKit

protocol UserProfileImageService {
    func downloadImage(photoId: String, url: String) -> AnyPublisher<UIImage, NetworkingError>
}

class UserProfileImageServiceImpl: UserProfileImageService, ObservableObject {
    
    private let networkService: NetworkRepository
    
    init(
        networkService: NetworkRepository = DIContainer.shared.resolve(NetworkRepository.self) ?? NetworkRepositoryImpl()
    ){
        self.networkService = networkService
    }
    
    func downloadImage(photoId: String, url: String) -> AnyPublisher<UIImage, NetworkingError> {
        
        guard let url = URL(string: url) else {
            return Fail(error: NetworkingError.invalidURL)
                .eraseToAnyPublisher()
        }

        if let cachedImage = CachingService.shared.getCachedImage(for: photoId) {
            LoggingService.shared.info("Using cached image for URL: \(url)")
            return Just(cachedImage)
                .setFailureType(to: NetworkingError.self)
                .eraseToAnyPublisher()
        }else {
            LoggingService.shared.error("No cached image found for URL: \(url.absoluteString)")
        }
        
        if let diskImage = FileStoreManager.shared.retrieveFromDisk(for: photoId) {
            LoggingService.shared.info("Using Disk image for URL: \(url), with id: \(photoId)")
            return Just(diskImage)
                .setFailureType(to: NetworkingError.self)
                .eraseToAnyPublisher()
        }
        
        return networkService.request(url)
            .tryMap { data, response in
                guard response is HTTPURLResponse else {
                    throw NetworkingError.invalidResponse
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let image = UIImage(data: data) else {
                    throw(NetworkingError.invalidResponse)
                }
                CachingService.shared.cacheImage(image, for: photoId)
                LoggingService.shared.info("Adding image to disk for URL: \(url), with id: \(photoId)")
                FileStoreManager.shared.addToDisk(image: image, for: photoId)
                return image
            }
            .mapError{ error in
                if error is NetworkingError {
                    return NetworkingError.unknown
                } else if error is URLError {
                    return .invalidURL
                } else {
                    return NetworkingError.decodingError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

