//
//  PhotoImageView.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import SwiftUI

struct PhotoHeaderView: View {
    
    @StateObject var userDatavm = UserDataViewModelImpl()
    
    var photo: Photo
    var tag: Tag
    
    var body: some View {
        HStack {
            if let image = userDatavm.images {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(50)
            } else {
                ProgressView()
                    .frame(width: 30, height: 30)
                    .cornerRadius(15)

            }
            Text(tag.authorname)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            userDatavm.loadUserProfilePic(for: photo)
        }
    }
}

#Preview {
    PhotoHeaderView(photo: Photo(id: "", owner: "", farm: 99, secret: "", server: "", title: ""), tag: Tag(id: "", author: "", authorname: "Senam Ahadzi", raw: ""))
}
