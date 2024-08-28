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
    func getPhotoSearch(userId: String?)
}

final class PhotoListViewModelImpl: PhotoListViewModel, ObservableObject {
    
    private let photoListService: PhotoListService
    private let imageRequestService: ImageRequestService
    private let tagService: TagListService
    
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    @Published var tags: [String: [Tag]] = [:]
    @Published var images: [String: UIImage] = [:]
    @Published var photoInfo: [String: PhotoInfo] = [:]
    
    private var isLoading = false
    private var hasLoaded = false
    private var lastUserID: String?
    
    let placeholderImage = UIImage(resource: .personPlaceholder)
    
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    private var isLastPage = false
    
    
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
        
        guard !isLoading else { return }
        
        if hasLoaded && userId == lastUserID {
            return
        }
        
//        guard let searchText = text else { return }
        
        photoListService.getPhotoList(userID: buildStringForUserID(userID: userId) ?? "" , page: currentPage)
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
                if photoObject.photos.photo?.isEmpty == true {
                    self.isLastPage = true
                } else {
                    self.photos.append(contentsOf: photoObject.photos.photo ?? [])
                    self.lastUserID = userId
                    self.currentPage += 1
                }
                photoObject.photos.photo?.forEach { photo in
                    self.loadImages(for: photo)
                    self.loadPhotoInfo(for: photo)
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadImages(for photo: Photo) {
        let photoID = photo.id
        
        guard images[photoID] == nil else { return }
        
        let imageURL = buildImageURL(photo: photo)
        
        imageRequestService.downloadImage(url: imageURL)
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    break
                case .failure(let error):
                    self.images[photoID] = self.placeholderImage
                    print("Error loading image for photo \(photoID): \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] image in
                self?.images[photoID] = image
            }
            .store(in: &cancellables)
    }
    
    func loadMorePhotos(userId: String?) {
        if !isLastPage {
            getPhotoSearch(userId: userId)
        }
    }
    
    private func loadPhotoInfo(for photo: Photo) {
        tagService.getTags(for: photo)
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    print("Tags are here")
                case .failure(let error):
                    print("Error getting tags for photo \(photo.id): \(error.localizedDescription)")
                    
                }
            } receiveValue: { [weak self] tags in
                guard let self = self else { return }
                if let tagList = tags.photo.tags?.tag {
                    self.tags[photo.id] = tagList
                }
                self.photoInfo[photo.id] = tags
            }
            .store(in: &cancellables)
    }
}

extension PhotoListViewModelImpl {
    func getPhotoWithTag(photoID: String) -> (photo: Photo, tag: Tag)? {
        guard let photo = photos.first(where: { $0.id == photoID }),
              let tagsForPhoto = tags[photoID],
              let specificTag = tagsForPhoto.first(where: { $0.author == photo.owner }) else {
            return nil
        }
        return (photo, specificTag)
    }
    // Come back and combine the two
    func getPhotoInfo(for photoID: String) -> PhotoInfo? {
        // First, find the photo based on the photoID
        guard let photo = photos.first(where: { $0.id == photoID }),
              let photoTag = photoInfo[photoID] else { // Retrieve the full PhotoTag object from the photoInfo dictionary
            return nil
        }
        return photoTag // Return the entire PhotoTag object
    }
    
    
    private func buildStringForUserID(userID: String?) -> String? {
        if let user = userID {
            return "&user_id=\(user)"
        }
        return nil
    }
    
    private func buildImageURL(photo: Photo) -> String {
        return "\(BaseUrl.photosUrl)\(photo.server)/\(photo.id)_\(photo.secret).jpg"
    }
}
