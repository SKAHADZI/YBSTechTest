//
//  PhotoListServiceTests.swift
//  YBSTechTestTests
//
//  Created by Senam Ahadzi on 01/09/2024.
//

import XCTest
import Combine
@testable import YBSTechTest

class PhotoListServiceTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    func createMockPhotoListService(
        photoId: String = "1",
        owner: String = "owner",
        farm: Int? = 1,
        secret: String = "secret",
        server: String? = "server",
        title: String = "title",
        page: Int = 1,
        pages: Int = 1,
        perpage: Int = 10,
        total: Int = 1
    ) -> MockPhotoListService {
        
        let mockPhoto = PhotoResponse(
            id: photoId,
            owner: owner,
            farm: farm,
            secret: secret,
            server: server,
            title: title
        )
        
        let mockPhotosResponse = PhotosResponse(
            page: page,
            pages: pages,
            perpage: perpage,
            total: total,
            photo: [mockPhoto]
        )
        
        let mockPhotoObject = PhotoObject(photos: mockPhotosResponse)
        
        let mockService = MockPhotoListService(mockData: mockPhotoObject)
        
        return mockService
    }
    
    func testPhotoListServiceSuccess() {
        // Given
        let mockService = createMockPhotoListService()

        
        // When
        let expectation = XCTestExpectation(description: "Successfully fetched photo list")
        
        mockService.getPhotoList(userID: "testUser", page: 1)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertEqual(response.photos.photo?.first?.id, "1")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPhotoListServiceFailure() {
        // Given
        let mockService = MockPhotoListService(mockStatusCode: 404, errorToReturn: .invalidResponse)
        
        // When
        let expectation = XCTestExpectation(description: "Failed to fetch photo list due to networking error")
        
        mockService.getPhotoList(userID: "testUser", page: 1)
            .sink(receiveCompletion: { completion in
                // Then
                if case let .failure(error) = completion {
                    XCTAssertEqual(error, .invalidResponse)
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
    
    func testPhotoResponseId() {
        // Given
        let mockService = createMockPhotoListService(photoId: "1")
        
        // When
        let expectation = XCTestExpectation(description: "Successfully fetched photo ID")
        
        mockService.getPhotoList(userID: "testUser", page: 1)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertEqual(response.photos.photo?.first?.id, "1")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPhotoResponseOwner() {
        // Given
        let mockService = createMockPhotoListService(owner: "Owner")

        // When
        let expectation = XCTestExpectation(description: "Successfully fetched photo owner")
        
        mockService.getPhotoList(userID: "testUser", page: 1)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertEqual(response.photos.photo?.first?.owner, "Owner")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPhotoResponseFarm() {
        // Given
        let mockService = createMockPhotoListService(farm: 66)


        // When
        let expectation = XCTestExpectation(description: "Successfully fetched photo farm")
        
        mockService.getPhotoList(userID: "testUser", page: 1)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertEqual(response.photos.photo?.first?.farm, 66)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPhotoResponseSecret() {
        // Given
        let mockService = createMockPhotoListService(secret: "secret")

        // When
        let expectation = XCTestExpectation(description: "Successfully fetched photo secret")
        
        mockService.getPhotoList(userID: "testUser", page: 1)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertEqual(response.photos.photo?.first?.secret, "secret")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPhotoResponseServer() {
        // Given
        let mockService = createMockPhotoListService(server: "Server")


        // When
        let expectation = XCTestExpectation(description: "Successfully fetched photo server")
        
        mockService.getPhotoList(userID: "testUser", page: 1)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertEqual(response.photos.photo?.first?.server, "Server")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPhotoResponseTitle() {
        // Given
        let mockService = createMockPhotoListService(title: "Title")


        // When
        let expectation = XCTestExpectation(description: "Successfully fetched photo title")
        
        mockService.getPhotoList(userID: "testUser", page: 1)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertEqual(response.photos.photo?.first?.title, "Title")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
