//
//  BaseDependencyManager.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import Foundation

struct DependencyManager {
    let container = DIContainer.shared
    
    init() {
        container.register(PhotoListServiceImpl(), for: PhotoListService.self)
        container.register(NetworkRepositoryImpl(), for: NetworkRepository.self)
        container.register(ImageRequestServiceImpl(), for: ImageRequestService.self)
        container.register(TagListServiceImpl(), for: TagListService.self)
        container.register(UserDetailServiceImpl(), for: UserDetailService.self)
        container.register(UserProfileImageServiceImpl(), for: UserProfileImageService.self)
    }
    
    func resolveNetworkService() -> NetworkRepository {
        return container.resolve(NetworkRepository.self) ?? NetworkRepositoryImpl()
    }
    
    func resolvePhotoListService() -> PhotoListService {
        return container.resolve(PhotoListService.self) ?? PhotoListServiceImpl()
    }
    
    func resolveImageRequestService() -> ImageRequestService {
        return container.resolve(ImageRequestService.self) ?? ImageRequestServiceImpl()
    }
    
    func resolveTagListService() -> TagListService {
        return container.resolve(TagListService.self) ?? TagListServiceImpl()
    }
    
    func resolveUserDetailService() -> UserDetailService {
        return container.resolve(UserDetailService.self) ?? UserDetailServiceImpl()
    }
    
    func resolveUserProfileImageService() -> UserProfileImageService {
        return container.resolve(UserProfileImageService.self) ?? UserProfileImageServiceImpl()
    }
}
