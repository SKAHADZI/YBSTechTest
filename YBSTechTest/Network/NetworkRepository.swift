//
//  NetworkRepository.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import Combine
import Foundation

protocol NetworkRepository {
    func request(_ url: URL) -> AnyPublisher<(data: Data, response: URLResponse), NetworkingError>
}

final class NetworkRepositoryImpl: NetworkRepository {
    func request(_ url: URL) -> AnyPublisher<(data: Data, response: URLResponse), NetworkingError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response in
                return (data: data, response: response)
            }
            .mapError {_ in
                return NetworkingError.networkingError
            }
            .eraseToAnyPublisher()
    }
}
