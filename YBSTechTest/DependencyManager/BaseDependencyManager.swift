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

    }
    
    func resolveNetworkService() -> NetworkRepository {
        return container.resolve(NetworkRepository.self) ?? NetworkRepositoryImpl()
    }
    
    func resolvePhotoListService() -> PhotoListService {
        return container.resolve(PhotoListService.self) ?? PhotoListServiceImpl()
    }
    
    func resolveCachingService() -> CachingService {
        return container.resolve(CachingService.self) ?? CachingServiceImpl()
    }
    
    func resolveImageRequestService() -> ImageRequestService {
        return container.resolve(ImageRequestService.self) ?? ImageRequestServiceImpl()
    }
}
