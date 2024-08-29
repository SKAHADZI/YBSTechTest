//
//  MockNetWorkRepository.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 29/08/2024.
//

import Combine
import Foundation

class MockNetworkRepository: NetworkRepository {
    var errorToReturn: NetworkingError?
    var mockData: Data?
    var mockStatusCode: Int

    init(mockData: Data? = nil, mockStatusCode: Int = 200, errorToReturn: NetworkingError? = nil) {
        self.mockData = mockData
        self.mockStatusCode = mockStatusCode
        self.errorToReturn = errorToReturn
    }

    func request(_ url: URL) -> AnyPublisher<(data: Data, response: URLResponse), NetworkingError> {
        if let error = errorToReturn {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }

        guard let data = mockData else {
            return Fail(error: NetworkingError.invalidResponse)
                .eraseToAnyPublisher()
        }

        let response = HTTPURLResponse(url: url, statusCode: mockStatusCode, httpVersion: nil, headerFields: nil)!

        if (200...299).contains(mockStatusCode) {
            return Just((data, response))
                .setFailureType(to: NetworkingError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkingError.unexpectedStatusCode(mockStatusCode))
                .eraseToAnyPublisher()
        }
    }
}
