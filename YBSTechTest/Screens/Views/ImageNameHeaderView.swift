//
//  PhotoImageView.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import SwiftUI

struct ImageNameHeaderView: View {
    
    @StateObject var userDatavm = UserDataViewModelImpl()
    
    var photo: PhotoResponse
    var photoInfo: PhotoInfo
    
    var body: some View {
        HStack {
            switch userDatavm.state {
            case .idle:
                ProgressView()
            case .loading:
                ProgressView("Loading...")
            case .success:
                HStack {
                    if let image = userDatavm.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(50)
                    } else {
                        ProgressView()
                            .frame(width: 30, height: 30)
                            .cornerRadius(15)
                        
                    }
                    Text(photoInfo.photo.owner.username)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            case .failure(let error):
                HStack {
                    if let image = userDatavm.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(50)
                    }
                    Text(photoInfo.photo.owner.username)
                }
            case .isLoadingMore:
                EmptyView()
            case .loadedAll:
                EmptyView()

            }
        }
        .onAppear {
            userDatavm.loadUserProfilePic(for: photo)
        }
    }
}

#Preview {
    ImageNameHeaderView(photo: Mocks.samplePhotoResponse, photoInfo: Mocks.samplePhotoInfo)
}
