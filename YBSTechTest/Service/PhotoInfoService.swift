//
//  TagListService.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import Combine
import Foundation

protocol PhotoInfoService {
    func getTags(for photo: PhotoResponse) -> AnyPublisher<PhotoInfo, NetworkingError>

}

class PhotoInfoServiceImpl: PhotoInfoService, ObservableObject {
    
    private let networkService: NetworkRepository
    private let decodingErrorHandler: DecodingErrorHandler
    
    init(networkService: NetworkRepository = DIContainer.shared.resolve(NetworkRepository.self) ?? NetworkRepositoryImpl(), decodingErrorHandler: DecodingErrorHandler = DecodingErrorHandler()) {
        self.networkService = networkService
        self.decodingErrorHandler = decodingErrorHandler
    }
    
    func getTags(for photo: PhotoResponse) -> AnyPublisher<PhotoInfo, NetworkingError> {
        
        guard let url = URL(string: "\(BaseUrl.baseUrl) /?method=flickr.photos.getInfo&api_key=\(APIKey.apiKey)&photo_id=\(photo.id)&format=json&nojsoncallback=1") else {
            return Fail(error: NetworkingError.invalidURL)
                .eraseToAnyPublisher()
        }
        print(url)
        
        let decoder = JSONDecoder()
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
            .decode(type: PhotoInfo.self, decoder: decoder)
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
