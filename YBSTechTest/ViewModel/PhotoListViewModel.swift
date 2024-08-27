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
    @Published var images: [(UIImage, Photo)] = []
    private var isLoading = false
    private var hasLoaded = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(photoListService: PhotoListService = DIContainer.shared.resolve(PhotoListService.self) ?? PhotoListServiceImpl(),
         imageRequestService: ImageRequestService = DIContainer.shared.resolve(ImageRequestService.self) ??
         ImageRequestServiceImpl()
    ) {
        self.photoListService = photoListService
        self.imageRequestService = imageRequestService
    }
    
    func getPhotoSearch(text: String? = "Yorkshire") {
        
        guard !isLoading, !hasLoaded else { return }
               isLoading = true
               hasLoaded = true // Set here
        
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
                self.loadImages()
            }
            .store(in: &cancellables)
    }
    
    func buildImageURL(photo: Photo) -> String {
        return "\(BaseUrl.photosUrl)\(photo.server)/\(photo.id)_\(photo.secret).jpg"
    }
    
    func loadImages() {
        guard let photos = photos?.photos.photo else { return }
        let photoID = photo.id
                
        guard images[photoID] == nil else {
                    return  // Image already loaded
        }
        
        let publisher = photos.map { photo in
            self.imageRequestService.downloadImage(url: self.buildImageURL(photo: photo))
                .map { image in (image, photo) }
                .catch { _ in Just((UIImage(), photo)) }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        Publishers.MergeMany(publisher)
            .collect()
            .sink { [weak self] combined in
                self?.images = combined
            }
            .store(in: &cancellables)
            
    }
}
