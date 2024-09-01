//
//  UserDetailViewModel.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import os
import Combine
import Foundation
import UIKit

protocol UserDetailViewModel {
    func loadUserProfilePic(for user: Photo)
}

final class UserDataViewModelImpl: UserDetailViewModel, ObservableObject {
    
    private let userProfileImageService: UserProfileImageService
    @Published var profile: Profile?
    @Published var profileImage:  UIImage?
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
                    self.state = .success
                case .failure(let error):
                    self.state = .failure(error)
                    self.profileImage = UIImage(resource: .personPlaceholder)
                    LoggingService.shared.error("\(error.localizedDescription)")
                }
            } receiveValue: { [weak self] image in
                guard let self = self else { return }
                self.profileImage = image
        }
            .store(in: &cancellables)
    }
}

extension UserDataViewModelImpl {
    
    private func buildImageURL(photo: Photo) -> String {
        guard let farm = photo.farm else { return "" }
        guard let server = photo.server else { return "" }
        print("buildImageURL: \(photo)")
        return "https://farm\(farm).staticflickr.com/\(server)/buddyicons/\(photo.owner).jpg"
    }
}
