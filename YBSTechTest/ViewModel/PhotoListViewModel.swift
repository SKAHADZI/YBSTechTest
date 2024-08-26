//
//  PhotoSearchViewModel.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import Combine
import Foundation
import UIKit

protocol PhotoListViewModel {
    func getPhotoSearch(text: String?)
}

final class PhotoListViewModelImpl: PhotoListViewModel, ObservableObject {
    
    private let photoListService: PhotoListService
    private let imageRequestService: ImageRequestService
    @Published var photos: PhotoObject?
    @Published var errorMessage: String?
    @Published var serverId: [String] = []
    @Published var secret: [String] = []
    @Published var id: [String] = []
    @Published var images: [UIImage] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(photoListService: PhotoListService = DIContainer.shared.resolve(PhotoListService.self) ?? PhotoListServiceImpl(),
         imageRequestService: ImageRequestService = DIContainer.shared.resolve(ImageRequestService.self) ??
         ImageRequestServiceImpl()
    ) {
        self.photoListService = photoListService
        self.imageRequestService = imageRequestService
    }
    
    func getPhotoSearch(text: String? = "Yorkshire") {
        
        guard let searchText = text else { return }
        
        photoListService.getPhotoList(text: searchText)
            .sink { [weak self] completionResult in
                switch completionResult {
                case .finished:
                    print("Completion successful")
                case .failure(let error):
                    // Using the errorDescription
                    self?.errorMessage = error.localizedDescription
                    print(error.errorDescription ?? "An unknown error occurred")
                    
                }
            } receiveValue: { [weak self] photoObject in
                guard let self = self else { return }
                self.photos = photoObject
                if let photoArray = photoObject.photos.photo {
                    self.serverId = photoArray.map { $0.server }
                    self.secret = photoArray.map { $0.secret }
                    self.id = photoArray.map { $0.id }
                }
            }
            .store(in: &cancellables)
    }
    
    func buildImageURL(photo: Photo) -> URL? {
        return URL(string: "\(BaseUrl.photosUrl)\(photo.server)/\(photo.id)_\(photo.secret).jpg")
    }

    func getPhotoImage() {
        imageRequestService.downloadImage(serverId: self.serverId, id: self.id, secret: self.secret)
            .sink { resultCompletion in
                switch resultCompletion {
                case .finished:
                    print("We got ya image")
                case .failure(let error):
                    print("ImageService: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] images in
                print(images)
                guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.images = images
                }
            }
            .store(in: &cancellables)
    }
}

