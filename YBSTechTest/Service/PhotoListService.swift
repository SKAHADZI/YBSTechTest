//
//  PhotoListService.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import Combine
import Foundation
import os

protocol PhotoListService {
    func getPhotoList(userID: String, page: Int) -> AnyPublisher<PhotoObject, NetworkingError>
}

class PhotoListServiceImpl: PhotoListService, ObservableObject {
    
    private let networkService: NetworkRepository
    private let decodingErrorHandler: DecodingErrorHandler
    // reusing everywhere lets make centralised one
    private let logger = Logger(subsystem: "com.SenSen.YBSTechTest", category: "networking")
    
    init(networkService: NetworkRepository = DIContainer.shared.resolve(NetworkRepository.self) ?? NetworkRepositoryImpl(), decodingErrorHandler: DecodingErrorHandler = DecodingErrorHandler()) {
        self.networkService = networkService
        self.decodingErrorHandler = decodingErrorHandler
    }
    
    // Should most likely be named userIDString as we're not pasing a userID are we???
    func getPhotoList(userID: String = "", page: Int) -> AnyPublisher<PhotoObject, NetworkingError> {
        
        // I could interpolate this whole string into the URL(string: but so much easier doing it this way.
        let input = "\(BaseUrl.baseUrl) /?method=flickr.photos.search&api_key=\(APIKey.apiKey)&text=Yorkshire\(userID)&safe_search=1&page=\(page)&per_page=100&format=json&nojsoncallback=1"
         
        // Unwrap 
        guard let url = URL(string: input) else {
            return Fail(error: NetworkingError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        logger.info("\(url.absoluteString)")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return networkService.request(url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkingError.invalidResponse
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkingError.unexpectedStatusCode(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: PhotoObject.self, decoder: decoder)
            .mapError { error -> NetworkingError in
                if let networkingError = error as? NetworkingError {
                    return networkingError
                } else if error is URLError {
                    return .networkingError
                } else {
                    return self.decodingErrorHandler.mapDecodingError(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
