//
//  PhotoSearchModel.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import Foundation

struct PhotoObject: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [Photo]?
}

struct Photo: Codable {
    let uuid = UUID()
    let id: String
    let owner: String
    let farm: Int
    let secret: String
    let server: String
    let title: String 
}
