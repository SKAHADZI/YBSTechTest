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
    func loadUserProfilePic(for user: Photo)
}

final class UserDataViewModelImpl: UserDetailViewModel, ObservableObject {
    
    private let userProfileImageService: UserProfileImageService
    @Published var profile: Profile?
    @Published var image:  UIImage?
    @Published var state: ViewState = .idle

    private var cancellables = Set<AnyCancellable>()
    
    init(
        userProfileImageService: UserProfileImageService = DIContainer.shared.resolve(UserProfileImageService.self) ?? UserProfileImageServiceImpl()
    ) {
        self.userProfileImageService = userProfileImageService
    }
    
    func loadUserProfilePic(for user: Photo) {
        
        state = .loading
        
        let imageURL = buildImageURL(photo: user)
        
        userProfileImageService.downloadImage(photoId: user.owner, url: imageURL)
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    print("\n Got user profile image")
                    self.state = .success
                case .failure(let error):
                    self.state = .failure(error)
                    self.image = UIImage(resource: .personPlaceholder)
                    print("Error loading image for user profile image \(user.id): \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] image in
                guard let self = self else { return }
                self.image = image
        }
            .store(in: &cancellables)
    }
}

extension UserDataViewModelImpl {
    
    private func buildImageURL(photo: Photo) -> String {
        return "https://farm\(photo.farm).staticflickr.com/\(photo.server)/buddyicons/\(photo.owner).jpg"
    }
}
