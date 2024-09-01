//
//  AppRoutes.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 01/09/2024.
//

import Foundation
import UIKit

enum AppRoutes: Hashable, Equatable {
    case home
    case userPhotoGrid(userID: String, authorName: String, userPhotoInfo: PhotoInfo, photo: PhotoResponse)
    case imageDetail(photo: PhotoResponse, image: UIImage, photoInfo: PhotoInfo)
    case profileDetail(photo: PhotoResponse, photoInfo: PhotoInfo)
}
