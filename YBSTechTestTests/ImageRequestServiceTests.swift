//
//  YBSTechTestTests.swift
//  YBSTechTestTests
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import XCTest
import Combine
@testable import YBSTechTest

class ImageRequestServiceTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    func testImageDownloadSuccess() {
        // Create a mock image
        let mockImage = UIImage(resource: .personPlaceholder)
        let mockService = MockImageRequestService(mockImages: ["test-photo-id": mockImage])
        
        // Perform the image download
        mockService.downloadImage(photoId: "test-photo-id", url: "http://example.com/image.jpg")
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, but got error: \(error.localizedDescription)")
                }
            }, receiveValue: { image in
                XCTAssertEqual(image, mockImage)
            })
            .store(in: &cancellables)
    }
    
    func testImageDownloadFailure() {
        let mockService = MockImageRequestService()
        
        mockService.downloadImage(photoId: "non-id", url: "http://example.com/image.jpg")
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTAssertEqual(error, NetworkingError.invalidResponse)
                } else {
                    XCTFail("Expected error, but got success")
                }
            }, receiveValue: { image in
                XCTFail("Expected no image, but got \(image)")
            })
            .store(in: &cancellables)
    }
}
