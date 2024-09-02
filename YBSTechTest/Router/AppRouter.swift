//
//  AppRouter.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 01/09/2024.
//

import Combine
import SwiftUI

class AppRouter: ObservableObject {
    @Published var currentRoute: AppRoutes?
    
    @ViewBuilder
    func navigate(to screen: AppRoutes) -> some View {
        switch screen {
        case .home:
            navigateToHomeView()
        case .userPhotoGrid(let userID, let authorName, let photoInfo, let photo):
            navigateToUserPhotoGridView(userID: userID, authorName: authorName, photoInfo: photoInfo, photo: photo)
        case .imageDetail(let photo, let image, let photoInfo):
            navigateToImageDetailView(photo: photo, image: image, photoInfo: photoInfo)
        case .profileDetail(let photo, let photoInfo):
            navigateToProfileDetailView(photo: photo, photoInfo: photoInfo)
        }
    }

    func navigateToHomeView() -> some View {
        return HomeView(router: self)
    }

    func navigateToUserPhotoGridView(userID: String, authorName: String, photoInfo: PhotoInfo, photo: PhotoResponse) -> some View {
        return UserPhotoGridView(userID: userID, authorName: authorName, userPhotoInfo: photoInfo, photo: photo, router: self)
    }

    func navigateToImageDetailView(photo: PhotoResponse, image: UIImage, photoInfo: PhotoInfo) -> some View {
        return ImageDetailView(photo: photo, image: image, photoInfo: photoInfo, router: self)
    }

    func navigateToProfileDetailView(photo: PhotoResponse, photoInfo: PhotoInfo) -> some View {
        return ProfileDetailHeaderView(photo: photo, photoInfo: photoInfo, router: self)
    }
}
