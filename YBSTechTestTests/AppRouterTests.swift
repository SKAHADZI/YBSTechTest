//
//  AppRouterTests.swift
//  YBSTechTestTests
//
//  Created by Senam Ahadzi on 02/09/2024.
//

import XCTest
import SwiftUI
@testable import YBSTechTest

final class AppRouterTests: XCTestCase {

    var router: AppRouter!

    override func setUpWithError() throws {
        router = AppRouter()
    }

    override func tearDownWithError() throws {
        router = nil
    }

    func testNavigateToHomeView() {
        // Given
        let expectedScreen = AppRoutes.home

        // When
        let view = router.navigate(to: expectedScreen)

        // Then
        XCTAssertNotNil(view)
    }

    func testNavigateToUserPhotoGridView() {
        // Given
        let expectedScreen = AppRoutes.userPhotoGrid(
            userID: "12345",
            authorName: "Sample Author",
            userPhotoInfo: Mocks.samplePhotoInfo,
            photo: Mocks.samplePhotoResponse
        )

        // When
        let view = router.navigate(to: expectedScreen)

        // Then
        XCTAssertNotNil(view)

    }

    func testNavigateToImageDetailView() {
        // Given
        let expectedScreen = AppRoutes.imageDetail(
            photo: Mocks.samplePhotoResponse,
            image: UIImage(systemName: "photo")!,
            photoInfo: Mocks.samplePhotoInfo
        )

        // When
        let view = router.navigate(to: expectedScreen)

        // Then
        XCTAssertNotNil(view)

    }

    func testNavigateToProfileDetailView() {
        // Given
        let expectedScreen = AppRoutes.profileDetail(
            photo: Mocks.samplePhotoResponse,
            photoInfo: Mocks.samplePhotoInfo
        )

        // When
        let view = router.navigate(to: expectedScreen)
        

        // Then
        XCTAssertNotNil(view)

    }
}
