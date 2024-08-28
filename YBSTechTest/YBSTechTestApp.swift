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
        _ = dependencyManager.resolveImageRequestService()
        _ = dependencyManager.resolveTagListService()
        
        let photoListService = dependencyManager.resolvePhotoListService()
        _photoSearchVm = StateObject(wrappedValue: PhotoListViewModelImpl(photoListService: photoListService))
        
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(photoSearchVm)
        }
    }
}
