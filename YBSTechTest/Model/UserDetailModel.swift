//
//  UserDetailModel.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import Foundation

struct Profile: Codable {
    let profile: ProfileDetails
}

struct ProfileDetails: Codable {
    let id: String
    let joinDate: String?
    let occupation: String?
    let hometown: String?
    let profile: String?
    let city: String?
    let country: String?
}
