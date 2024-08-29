//
//  ImageDetailView.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import SwiftUI

struct ImageDetailView: View {
    
    var photo: Photo
    var image: UIImage
    var tag: Tag
    var photoInfo: PhotoInfo

    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    PhotoHeaderView(photo: photo, tag: tag)
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .clipped()
                    Text(photo.title)
                        .font(.headline)
                        .padding(.top, 8)
                    
                    if let formattedDate = photoInfo.photo.formattedDate {
                        Text(formattedDate)
                            .font(.subheadline)
                    }
                    
                    Text("Views: \(photoInfo.photo.views)")
                    
                    Text(photoInfo.photo.description._content)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 8)
                    Spacer()
                }.navigationTitle(tag.authorname)
                
                    .padding(.horizontal, 8)
                    .padding(.vertical, nil)
            }
        }
    }
}

//#Preview {
//    ImageDetailView(photo: Photo(id: "", owner: "", farm: 66, secret: "", server: "", title: ""), image: UIImage(), tag: Tag(id: "", author: "", authorname: "", raw: ""), photoInfo: PhotoTag(id: "", tags: Tags[(id: "", author: "", authorname: "", raw: "")], server: "", farm: 99, dateuploaded: "", owner: Owner(username: "", realName: "", location: "", iconServer: "", iconFram: 99, path_alias: ""), title: "", description: "", views: ""))
//}
