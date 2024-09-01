//
//  PhotoInfoTests.swift
//  YBSTechTestTests
//
//  Created by Senam Ahadzi on 01/09/2024.
//

import XCTest
import Combine
@testable import YBSTechTest


class MockPhotoInfoServiceTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    func testGetTagsSuccess() {
        // Given
        let mockTag = Tag(id: "1", author: "author", authorname: "Author Name", raw: "rawTag")
        let mockTags = Tags(tag: [mockTag])
        let mockOwner = Owner(nsid: "ownerID", username: "ownerUsername", realname: "Owner Realname", location: "Location", iconserver: "iconServer", iconfarm: 1, path_alias: "alias")
        let mockContent = Content(_content: "SampleSample")
        let mockPhotoModel = PhotoModel(
            id: "photoID",
            tags: mockTags,
            server: "server",
            farm: 1,
            dateuploaded: "1695000000", // Some timestamp
            owner: mockOwner,
            title: mockContent,
            description: mockContent,
            views: "1000"
        )
        let mockPhotoInfo = PhotoInfo(photo: mockPhotoModel)
        
        let mockService = MockPhotoInfoService(mockData: mockPhotoInfo)
        
        // When
        let expectation = XCTestExpectation(description: "Successfully fetched tags")
        
        mockService.getTags(for: PhotoResponse(id: "photoID", owner: "owner", farm: 1, secret: "secret", server: "server", title: "title"))
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { photoInfo in
                // Then
                XCTAssertEqual(photoInfo.photo.id, "photoID")
                XCTAssertEqual(photoInfo.photo.tags?.tag.first?.id, "1")
                XCTAssertEqual(photoInfo.photo.owner.nsid, "ownerID")
                XCTAssertEqual(photoInfo.photo.title._content, "SampleSample")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetTagsFailure() {
        // Given
        let mockService = MockPhotoInfoService(errorToReturn: .networkingError)
        
        // When
        let expectation = XCTestExpectation(description: "Received networking error")
        
        mockService.getTags(for: PhotoResponse(id: "photoID", owner: "owner", farm: 1, secret: "secret", server: "server", title: "title"))
            .sink(receiveCompletion: { completion in
                // Then
                if case let .failure(error) = completion {
                    XCTAssertEqual(error, NetworkingError.networkingError)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected no data, but got a response")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetTagsInvalidResponse() {
        // Given
        let mockService = MockPhotoInfoService(mockData: nil)
        
        // When
        let expectation = XCTestExpectation(description: "Received invalid response error")
        
        mockService.getTags(for: PhotoResponse(id: "photoID", owner: "owner", farm: 1, secret: "secret", server: "server", title: "title"))
            .sink(receiveCompletion: { completion in
                // Then
                if case let .failure(error) = completion {
                    XCTAssertEqual(error, NetworkingError.invalidResponse)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected no data, but got a response")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFormattedDate() {
        // Given
        let dateUploaded = "1695000000" // Timestamp corresponding to a specific date
        let mockOwner = Owner(nsid: "ownerID", username: "ownerUsername", realname: "Owner Realname", location: "Location", iconserver: "iconServer", iconfarm: 1, path_alias: "alias")
        let mockContent = Content(_content: "SampleSample")
        let mockPhotoModel = PhotoModel(
            id: "photoID",
            tags: nil,
            server: "server",
            farm: 1,
            dateuploaded: dateUploaded,
            owner: mockOwner,
            title: mockContent,
            description: mockContent,
            views: "1000"
        )
        
        // When
        let formattedDate = mockPhotoModel.formattedDate
        
        // Then
        XCTAssertEqual(formattedDate, "18 Sep 2023") // Update to the correct date based on the timestamp
    }
}
