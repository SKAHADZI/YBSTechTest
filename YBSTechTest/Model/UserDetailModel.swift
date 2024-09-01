//
//  UserDetailModel.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import Foundation

// In future iterations I could add some extra details to the 

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
