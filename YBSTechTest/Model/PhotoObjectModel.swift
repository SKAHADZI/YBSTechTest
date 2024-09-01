//
//  PhotoSearchModel.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import Foundation

struct PhotoObject: Codable {
    let photos: PhotosResponse
}

struct PhotosResponse: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [PhotoResponse]?
}

struct PhotoResponse: Codable {
    let uuid = UUID()
    let id: String
    let owner: String
    let farm: Int?
    let secret: String
    let server: String?
    let title: String 
}
