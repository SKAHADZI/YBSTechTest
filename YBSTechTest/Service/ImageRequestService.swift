//
//  ImageRequestService.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import Combine
import Foundation
import SwiftUI

protocol ImageRequestService {
    func downloadImage(serverId: [String], id: [String], secret: [String]) -> AnyPublisher<[UIImage], NetworkingError>
}

class ImageRequestServiceImpl: ImageRequestService, ObservableObject {
    
    private let networkService: NetworkRepository
    private let cachingService: CachingService
    
    
    init(
        networkService: NetworkRepository = DIContainer.shared.resolve(NetworkRepository.self) ?? NetworkRepositoryImpl(),
        cachingService: CachingService = DIContainer.shared.resolve(CachingService.self) ?? CachingServiceImpl()
        
    ){
        self.networkService = networkService
        self.cachingService = cachingService
    }
    
    func downloadImage(serverId: [String], id: [String], secret: [String]) -> AnyPublisher<[UIImage], NetworkingError> {
        
        guard serverId.count == id.count, id.count == secret.count else {
            print("Mismatch in array lengths: serverId(\(serverId.count)), id(\(id.count)), secret(\(secret.count))")
                   return Fail(error: NetworkingError.invalidURL)
                       .eraseToAnyPublisher()
        }
        
        let imagePublishers: [AnyPublisher<UIImage, NetworkingError>] = serverId.indices.map { index in
            
            let serverId = serverId[index]
            let id = id[index]
            let secret = secret[index]
            
            guard let url = URL(string: "\(BaseUrl.photosUrl)\(serverId)/\(id)_\(secret).jpg") else {
                print("Invalid URL: \(BaseUrl.photosUrl)\(serverId)/\(id)_\(secret).jpg")
                return Fail(error: NetworkingError.invalidURL)
                    .eraseToAnyPublisher()
            }
            print(url)
#warning("Dont forget to store on disk")
            if let cachedImage = cachingService.getCachedImage(for: url.description) {
                print("Using cached image for URL: \(url)")
                return Just(cachedImage)
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
                    self.cachingService.cacheImage(image, for: url.description)
                    return image
                }
                .mapError{ error in
                    if error is NetworkingError {
                        return NetworkingError.networkingError
                    } else if error is URLError {
                        return .networkingError
                    } else {
                        return NetworkingError.decodingError
                    }
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(imagePublishers)
                    .collect()
                    .eraseToAnyPublisher()
    }
}
