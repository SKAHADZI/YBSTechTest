//
//  MockPhotoListService.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 29/08/2024.
//

import Combine
import Foundation

class MockPhotoListService: PhotoListService {
    var errorToReturn: NetworkingError?
    var mockData: PhotoObject?
    var mockStatusCode: Int

    init(mockData: PhotoObject? = nil, mockStatusCode: Int = 200, errorToReturn: NetworkingError? = nil) {
        self.mockData = mockData
        self.mockStatusCode = mockStatusCode
        self.errorToReturn = errorToReturn
    }

    func getPhotoList(userID: String, page: Int) -> AnyPublisher<PhotoObject, NetworkingError> {
        if let error = errorToReturn {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        guard let data = mockData else {
            return Fail(error: NetworkingError.invalidResponse)
                .eraseToAnyPublisher()
        }
        
        if (200...299).contains(mockStatusCode) {
            return Just(data)
                .setFailureType(to: NetworkingError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkingError.unexpectedStatusCode(mockStatusCode))
                .eraseToAnyPublisher()
        }
    }
}
