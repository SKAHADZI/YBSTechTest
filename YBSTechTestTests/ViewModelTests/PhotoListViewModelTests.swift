import XCTest
import Combine
@testable import YBSTechTest

final class PhotoListViewModelImplTests: XCTestCase {

    var viewModel: PhotoListViewModelImpl!
    var mockPhotoListService: MockPhotoListService!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockPhotoListService = nil
        cancellables = nil
    }

    func testGetPhotoSearchSuccess() {
        // Given
        let expectedPhotos = [Mocks.samplePhotoResponse]
        let photoObject = PhotoObject(photos: PhotosResponse(page: 1, pages: 1, perpage: 10, total: 10, photo: expectedPhotos))
        mockPhotoListService = MockPhotoListService(mockData: photoObject)
        viewModel = PhotoListViewModelImpl(photoListService: mockPhotoListService)

        // When
        viewModel.getPhotoSearch(userId: nil)

        // Then
        XCTAssertEqual(viewModel.viewState, .success)
        XCTAssertEqual(viewModel.photos, expectedPhotos)
    }

    func testGetPhotoSearchFailureWithCustomError() {
        // Given
        mockPhotoListService = MockPhotoListService(errorToReturn: .invalidResponse)
        viewModel = PhotoListViewModelImpl(photoListService: mockPhotoListService)

        // When
        viewModel.getPhotoSearch(userId: nil)

        // Then
        XCTAssertEqual(viewModel.viewState, .failure(NetworkingError.invalidResponse))
        XCTAssertEqual(viewModel.errorMessage, NetworkingError.invalidResponse.localizedDescription)
        XCTAssertTrue(viewModel.photos.isEmpty)
    }

    func testGetPhotoSearchFailureWithUnexpectedStatusCode() {
        // Given
        mockPhotoListService = MockPhotoListService(mockStatusCode: 404, errorToReturn: .unexpectedStatusCode(404))
        viewModel = PhotoListViewModelImpl(photoListService: mockPhotoListService)

        // When
        viewModel.getPhotoSearch(userId: nil)

        // Then
        XCTAssertEqual(viewModel.viewState, .failure(NetworkingError.unexpectedStatusCode(404)))
        XCTAssertEqual(viewModel.errorMessage, NetworkingError.unexpectedStatusCode(404).localizedDescription)
        XCTAssertTrue(viewModel.photos.isEmpty)
    }
    
}

