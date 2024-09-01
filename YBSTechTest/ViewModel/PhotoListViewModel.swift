//
//  PhotoSearchViewModel.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import Combine
import Foundation
import os
import UIKit

protocol PhotoListViewModel {
    func getPhotoSearch(userId: String?)
}

final class PhotoListViewModelImpl: PhotoListViewModel, ObservableObject {
    
    private let photoListService: PhotoListService
    private let imageRequestService: ImageRequestService
    private let tagService: TagListService
    
    @Published var viewState: ViewState = .idle
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    @Published var tags: [String: [Tag]] = [:]
    @Published var images: [String: UIImage] = [:]
    @Published var photoInfo: [String: PhotoInfo] = [:]
    
    private var hasLoaded = false
    private var lastUserID: String?
    var dataLoaded = false
    
    let placeholderImage = UIImage(resource: .personPlaceholder)
    
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    private var isLastPage = false
    
    private let logger = Logger(subsystem: "com.SenSen.YBSTechTest", category: "networking")
    
    
    init(photoListService: PhotoListService = DIContainer.shared.resolve(PhotoListService.self) ?? PhotoListServiceImpl(),
         imageRequestService: ImageRequestService = DIContainer.shared.resolve(ImageRequestService.self) ??
         ImageRequestServiceImpl(),
         tagListService: TagListService = DIContainer.shared.resolve(TagListService.self) ?? TagListServiceImpl()
    ) {
        self.photoListService = photoListService
        self.imageRequestService = imageRequestService
        self.tagService = tagListService
    }
    
    func getPhotoSearch(userId: String?) {
        
        guard viewState == .idle || viewState == .success || viewState == .isLoadingMore else { return }
           guard !isLastPage else {
               viewState = .loadedAll
               return
           }

        viewState = viewState == .success ? .isLoadingMore : .loading
        
        viewState = .loading
                
        photoListService.getPhotoList(userID: buildStringForUserID(userID: userId) ?? "" , page: currentPage)
            .sink { [weak self] completionResult in
                guard let self = self else { return }
                switch completionResult {
                case .finished:
                    break
                case .failure(let error):
                    // Using the errorDescription
                    self.viewState = .failure(error)
                    self.errorMessage = error.localizedDescription
                    logger.error("\(error.localizedDescription)")
                }
            } receiveValue: { [weak self] photoObject in
                guard let self = self else { return }
                // Safely unwrap the new photos
                guard let newPhotos = photoObject.photos.photo, !newPhotos.isEmpty else {
                    self.isLastPage = true
                    self.viewState = .success
                    return
                }
                // Append new photos to the existing photos array
                self.photos.append(contentsOf: newPhotos)
                self.currentPage += 1
                self.dataLoaded = true
                
                // Load images and tags for the new photos
                DispatchQueue.global(qos: .background).async {
                    
                    newPhotos.forEach { photo in
                        self.loadImages(for: photo)
                        self.loadPhotoInfo(for: photo)
                    }
                }
                
                self.viewState = .success
            }
            .store(in: &cancellables)
    }
    
    func loadMorePhotos(userId: String?) {
        print("loadMorePhotos called")
           guard viewState != .loading && viewState != .isLoadingMore && !isLastPage else {
               print("Pagination stopped: \(viewState) or no more pages.")
               return
           }
           getPhotoSearch(userId: userId)
    }
    
    private func loadImages(for photo: Photo) {
        let photoID = photo.id
        
        guard images[photoID] == nil else { return }
        
        let imageURL = buildImageURL(photo: photo)
        
        imageRequestService.downloadImage(photoId: photo.id, url: imageURL)
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    break
                case .failure(let error):
                    self.viewState = .failure(error)
                    self.images[photoID] = self.placeholderImage
                    self.logger.error("Error loading image for photo \(photoID): \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] image in
                DispatchQueue.main.async {
                    self?.images[photoID] = image
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadPhotoInfo(for photo: Photo) {
        tagService.getTags(for: photo)
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    self.logger.info("Tags are here")
                case .failure(let error):
                    self.viewState = .failure(error)
                    self.logger.error("Error getting tags for photo \(photo.id): \(error.localizedDescription)")
                    
                }
            } receiveValue: { [weak self] tags in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let tagList = tags.photo.tags?.tag {
                        self.tags[photo.id] = tagList
                    }
                    self.photoInfo[photo.id] = tags
                }
               
            }
            .store(in: &cancellables)
    }
}

extension PhotoListViewModelImpl {
    func getPhotoWithTag(photoID: String) -> [Tag]? {
        guard let tagsForPhoto = tags[photoID] else {
               return []
           }
           return tagsForPhoto
    }
    
    // Come back and combine the two
    func getPhotoInfo(for photoID: String) -> PhotoInfo? {
        
        let photoTag = photoInfo[photoID]
        return photoTag // Return the entire PhotoTag object
    }
    
    
    private func buildStringForUserID(userID: String?) -> String? {
        if let user = userID {
            return "&user_id=\(user)"
        }
        return nil
    }
    
    private func buildImageURL(photo: Photo) -> String {
        guard let server = photo.server else { return "" }
        return "\(BaseUrl.photosUrl)\(server)/\(photo.id)_\(photo.secret).jpg"
    }
}
