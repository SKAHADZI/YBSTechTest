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
    func downloadImage(url: String) -> AnyPublisher<UIImage, NetworkingError>
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
    
    func downloadImage(url: String) -> AnyPublisher<UIImage, NetworkingError> {
        
        guard let url = URL(string: url) else {
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
        } else {
            print("Unable to fetch from cache")
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
                print("/n/n caching image")
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
}
