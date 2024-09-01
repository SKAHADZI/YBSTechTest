//
//  ProfileDetailHeaderView.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 01/09/2024.
//

import SwiftUI

struct ProfileDetailHeaderView: View {
    
    var photo: PhotoResponse
    var photoInfo: PhotoInfo
    let router: AppRouter

    @StateObject private var userDataVm = UserDataViewModelImpl()

    var body: some View {
           VStack {
               if let image = userDataVm.profileImage {
                   Image(uiImage: image)
                       .resizable()
                       .frame(width: 50, height: 50)
                       .cornerRadius(50)
               } else {
                   ProgressView()
                       .frame(width: 30, height: 30)
                       .cornerRadius(15)
                   
               }
               
               Text(photoInfo.photo.owner.username)
               Text(photoInfo.photo.owner.realname)
               
               if let userLocation = photoInfo.photo.owner.location {
                   Text(userLocation)
               }

           }
           .onAppear {
               userDataVm.loadUserProfilePic(for: photo)
           }
       }
}

#Preview {
    ProfileDetailHeaderView(photo: Mocks.samplePhotoResponse, photoInfo: Mocks.samplePhotoInfo, router: AppRouter())
}
