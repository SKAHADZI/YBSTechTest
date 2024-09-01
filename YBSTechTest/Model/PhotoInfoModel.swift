//
//  TagModel.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import Foundation

struct PhotoInfo: Codable, Hashable, Equatable {
    let photo: PhotoModel
}

struct PhotoModel: Codable, Hashable, Equatable {
    let id: String?
    let tags: Tags?
    let server: String?
    let farm: Int?
    let dateuploaded: String
    let owner: Owner
    let title: Content
    let description: Content
    let views: String
    
    var formattedDate: String? {
        guard let dateDouble = Double(dateuploaded) else { return nil }
        let uploadedDate = Date(timeIntervalSince1970: dateDouble)
        let formatter = DateFormatter()
            formatter.dateFormat = "d MMM y"
        return formatter.string(from: uploadedDate)
        }
}

struct Content: Codable, Hashable, Equatable {
    let _content: String
}

struct Owner: Codable, Hashable, Equatable {
    let nsid: String
    let username: String
    let realname: String
    let location: String?
    let iconserver: String
    let iconfarm: Int
    let path_alias: String?
}

struct Tags: Codable, Hashable, Equatable {
    let tag: [Tag]
}

struct Tag: Codable, Hashable, Equatable {
    let id: String
    let author: String
    let authorname: String 
    let raw: String
}
