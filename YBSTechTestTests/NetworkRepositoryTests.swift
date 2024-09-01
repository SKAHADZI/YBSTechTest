//
//  NetworkRepositoryTests.swift
//  YBSTechTestTests
//
//  Created by Senam Ahadzi on 01/09/2024.
//

import XCTest
import Combine
@testable import YBSTechTest

class MockNetworkRepositoryTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    func testRequestSuccess() {
        // Given
        let expectedData = "Mock response data".data(using: .utf8)!
        let mockRepository = MockNetworkRepository(mockData: expectedData, mockStatusCode: 200)

        // When
        let expectation = XCTestExpectation(description: "Successfully fetched data")

        mockRepository.request(URL(string: "https://example.com")!)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { data, response in
                // Then
                XCTAssertEqual(data, expectedData)
                XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 200)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testRequestFailureWithError() {
        // Given
        let mockRepository = MockNetworkRepository(errorToReturn: .networkingError)

        // When
        let expectation = XCTestExpectation(description: "Received networking error")

        mockRepository.request(URL(string: "https://example.com")!)
            .sink(receiveCompletion: { completion in
                // Then
                if case let .failure(error) = completion {
                    XCTAssertEqual(error, NetworkingError.networkingError)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _, _ in
                XCTFail("Expected no data, but got a response")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testRequestFailureWithInvalidResponse() {
        // Given
        let mockRepository = MockNetworkRepository(mockData: nil)

        // When
        let expectation = XCTestExpectation(description: "Received invalid response error")

        mockRepository.request(URL(string: "https://example.com")!)
            .sink(receiveCompletion: { completion in
                // Then
                if case let .failure(error) = completion {
                    XCTAssertEqual(error, NetworkingError.invalidResponse)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _, _ in
                XCTFail("Expected no data, but got a response")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testRequestFailureWithUnexpectedStatusCode() {
        // Given
        let expectedData = "Mock response data".data(using: .utf8)!
        let mockRepository = MockNetworkRepository(mockData: expectedData, mockStatusCode: 404)

        // When
        let expectation = XCTestExpectation(description: "Received unexpected status code error")

        mockRepository.request(URL(string: "https://example.com")!)
            .sink(receiveCompletion: { completion in
                // Then
                if case let .failure(error) = completion {
                    XCTAssertEqual(error, NetworkingError.unexpectedStatusCode(404))
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _, _ in
                XCTFail("Expected no data, but got a response")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
