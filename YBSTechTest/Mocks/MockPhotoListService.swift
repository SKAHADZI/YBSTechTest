//
//  MockPhotoListService.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 29/08/2024.
//

import Combine
import Foundation

class MockPhotoListService: PhotoListService {
    var shouldReturnError: Bool
        var mockPhotos: [Photo]
        var mockPage: Int
        var mockPages: Int
        var mockTotal: Int
    
    init(
        shouldReturnError: Bool = false,
        mockPhotos: [Photo] = [],
        mockPage: Int = 1,
        mockPages: Int = 1,
        mockTotal: Int = 100
    ) {
        self.shouldReturnError = shouldReturnError
        self.mockPhotos = mockPhotos
        self.mockPage = mockPage
        self.mockPages = mockPages
        self.mockTotal = mockTotal
    }
    
    func getPhotoList(userID: String, page: Int) -> AnyPublisher<PhotoObject, NetworkingError> {
        if shouldReturnError {
            return Fail(error: NetworkingError.networkingError)
                .eraseToAnyPublisher()
        } else {
            let photoObject = PhotoObject(photos: Photos(page: mockPage, pages: mockPages, perpage: 100, total: mockTotal, photo: mockPhotos))
            return Just(photoObject)
                .setFailureType(to: NetworkingError.self)
                .eraseToAnyPublisher()
        }
    }
}
