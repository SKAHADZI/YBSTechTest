//
//  UserDetailService .swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import Combine
import Foundation

protocol UserDetailService {
    func loadUserDetails(for owner: Photo) -> AnyPublisher<Profile, NetworkingError>
}

class UserDetailServiceImpl: UserDetailService, ObservableObject {
    
    private let networkService: NetworkRepository
    private let decodingErrorHandler: DecodingErrorHandler
    
    init(networkService: NetworkRepository = DIContainer.shared.resolve(NetworkRepository.self) ?? NetworkRepositoryImpl(), decodingErrorHandler: DecodingErrorHandler = DecodingErrorHandler()) {
        self.networkService = networkService
        self.decodingErrorHandler = decodingErrorHandler
    }
    
    func loadUserDetails(for owner: Photo) -> AnyPublisher<Profile, NetworkingError> {
        
        guard let url = URL(string: "\(BaseUrl.baseUrl) /?method=flickr.profile.getProfile&api_key=\(APIKey.apiKey)&user_id=\(owner.owner)&format=json&nojsoncallback=1")
                            else {
            return Fail(error: NetworkingError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
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
            .decode(type: Profile.self, decoder: decoder)
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
