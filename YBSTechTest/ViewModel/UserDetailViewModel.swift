//
//  UserDetailViewModel.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import Combine
import Foundation
import UIKit

protocol UserDetailViewModel {
    func loadUserDetails(for owner: Photo)
}

final class UserDataViewModelImpl: UserDetailViewModel, ObservableObject {
    
    private let userDetailService: UserDetailService
    private let userProfileImageService: UserProfileImageService
    @Published var profile: Profile?
    @Published var images:  UIImage?
    @Published var photos: PhotoObject?

    private var cancellables = Set<AnyCancellable>()
    
    init(
        userDataService: UserDetailService = DIContainer.shared.resolve(UserDetailService.self) ?? UserDetailServiceImpl(),
        userProfileImageService: UserProfileImageService = DIContainer.shared.resolve(UserProfileImageService.self) ?? UserProfileImageServiceImpl()
    ) {
        self.userDetailService = userDataService
        self.userProfileImageService = userProfileImageService
    }
    
    func loadUserDetails(for owner: Photo) {
        userDetailService.loadUserDetails(for: owner)
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    print("Tags are here")
                case .failure(let error):
                    print("Error getting profile for \(owner.id): \(error.localizedDescription)")
                    
                }
            } receiveValue: { [weak self] profile in
                guard let self = self else { return }
                self.profile = profile
            }
            .store(in: &cancellables)
    }
    

    func buildImageURL(photo: Photo) -> String {
        return "https://farm\(photo.farm).staticflickr.com/\(photo.server)/buddyicons/\(photo.owner).jpg"
    }
    
    func loadUserProfilePic(for user: Photo) {
        
        let imageURL = buildImageURL(photo: user)
        
        userProfileImageService.downloadImage(url: imageURL)
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    print("\n Got user profile image")
                case .failure(let error):
                    print("Error loading image for user profile image \(user.id): \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] image in
                self?.images = image
            }
            .store(in: &cancellables)
    }
}
