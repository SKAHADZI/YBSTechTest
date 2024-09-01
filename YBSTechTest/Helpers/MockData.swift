//
//  MockData.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 01/09/2024.
//
import Foundation

struct Mocks {
    
    static let samplePhotoObject = PhotoObject(
        photos: Mocks.samplePhotosResponse
    )

    static let samplePhotosResponse = PhotosResponse(
        page: 1,
        pages: 10,
        perpage: 20,
        total: 200,
        photo: [Mocks.samplePhotoResponse]
    )

    static let samplePhotoResponse = PhotoResponse(
        id: "samplePhotoID",
        owner: "sampleOwnerID",
        farm: 1,
        secret: "sampleSecret",
        server: "sampleServer",
        title: "Sample Photo Title"
    )
    
    static let samplePhotoInfo = PhotoInfo(
        photo: Mocks.samplePhotoModel
    )

    static let samplePhotoModel = PhotoModel(
        id: "samplePhotoID",
        tags: Mocks.sampleTags,
        server: "sampleServer",
        farm: 1,
        dateuploaded: "1693534800",
        owner: Mocks.sampleOwner,
        title: Mocks.sampleContent,
        description: Mocks.sampleContent,
        views: "1234"
    )

    static let sampleContent = Content(
        _content: "Sample Content"
    )

    static let sampleOwner = Owner(
        nsid: "sampleNSID",
        username: "sampleUsername",
        realname: "Sample Realname",
        location: "Sample Location",
        iconserver: "sampleIconServer",
        iconfarm: 1,
        path_alias: "samplePathAlias"
    )
    
    static let sampleTags = Tags(
        tag: [Mocks.sampleTag]
    )

    static let sampleTag = Tag(
        id: "sampleTagID",
        author: "sampleAuthor",
        authorname: "Sample Author Name",
        raw: "Sample Raw Tag"
    )

    static let sampleProfile = Profile(
        profile: Mocks.sampleProfileDetails
    )

    static let sampleProfileDetails = ProfileDetails(
        id: "sampleProfileID",
        joinDate: "2020-01-01",
        occupation: "Software Engineer",
        hometown: "Sample Hometown",
        profile: "This is a sample profile.",
        city: "Sample City",
        country: "Sample Country"
    )
}
