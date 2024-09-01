//
//  MockImageRequestService.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 01/09/2024.
//

import Combine
import Foundation
import UIKit

class MockImageRequestService: ImageRequestService {

    private let mockImages: [String: UIImage]
    
    init(mockImages: [String: UIImage] = [:]) {
        self.mockImages = mockImages
    }
    
    func downloadImage(photoId: String, url: String) -> AnyPublisher<UIImage, NetworkingError> {
        if let image = mockImages[photoId] {
            return Just(image)
                .setFailureType(to: NetworkingError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: .invalidResponse)
                .eraseToAnyPublisher()
        }
    }
}
