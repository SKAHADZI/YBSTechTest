//
//  YBSTechTestApp.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import SwiftUI

@main
struct YBSTechTestApp: App {
    
    let dependencyManager = DependencyManager()
    @StateObject private var photoSearchVm: PhotoListViewModelImpl

    init() {
        _ = dependencyManager.resolveNetworkService()
        _ = dependencyManager.resolveCachingService()
        _ = dependencyManager.resolveImageRequestService()
        
        let photoListService = dependencyManager.resolvePhotoListService()
        _photoSearchVm = StateObject(wrappedValue: PhotoListViewModelImpl(photoListService: photoListService))
    }
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(photoSearchVm)
        }
    }
}
