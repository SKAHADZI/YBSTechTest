//
//  PhotoCardView.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 28/08/2024.
//

import SwiftUI

struct PhotoCardView: View {
    
    @EnvironmentObject var vm: PhotoListViewModelImpl
    let photo: Photo
    let image: UIImage
    let photoInfo: PhotoInfo?
    let photoID: String
    var body: some View {
        
        if let photoInfo = photoInfo {
            
            VStack(alignment: .leading, spacing: nil) {
                NavigationLink(destination: UserPhotoGridView(userID: photoInfo.photo.owner.nsid, authorName: photoInfo.photo.owner.username, userPhotoInfo: photoInfo, photo: photo)) {
                    ImageNameHeaderView(photo: photo, photoInfo: photoInfo)
                }
                
                NavigationLink {
                    ImageDetailView(
                        photo: photo,
                        image: image,
                        photoInfo: photoInfo
                    )
                } label: {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .clipped()
                }.padding(.vertical, 8)
                
                Text(photo.title)
                Text(photo.owner)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                
                if let tags = vm.getPhotoWithTag(photoID: photo.id), !tags.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(tags, id: \.id) { photoTag in
                                TagBody(tag: photoTag).scaledToFit()
                                    .padding(.leading, 8)
                            }
                        }
                    }
                }
            }
            .padding()
          
        } else {
            Image(uiImage: .placeholder)
                .resizable()
                .frame(width: 500, height: 500)
            Text("Unable to load User")
        }
        
    }
}

//#Preview {
//    PhotoCardView(photo: Photo(id: "53950013463", owner: "64929537@N05", farm: 66, secret: "003027b3b8", server: "65535", title: "The Castle Museum, York"), image: UIImage(resource: .insta), tag: Tag(id: "192028653-53954728345-24658", author: "192073975@N06", authorname: "D Colclough", raw: "NorthYorkMoors"), photoInfo: PhotoInfo(photo: PhotoModel(id: "53950243942", tags: Tags(tag: [Tag(id: "192028653-53954728345-24658", author: "192073975@N06", authorname: "D Colclough", raw: "NorthYorkMoors")]), server: "65535", farm: 66, dateuploaded: "1724752686", owner: Owner(username: "kitmasterbloke", realname: "Steve Knight", location: "Halstead, United Kingdom", iconserver: "7295", iconfarm: 8, path_alias: "kitmasterbloke"), title: Content(_content: "The Castle Museum, York"), description: Content(_content: "A walk around the City of York with a visit to the newly-refurbished Keep of York Castle known as Clifford's Tower."), views: "23")), photoID: "53950243942", isSheetPresented: .constant(false))
//}
