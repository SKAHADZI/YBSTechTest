//
//  PhotoCardView.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 28/08/2024.
//

import SwiftUI

struct PhotoCardView: View {
    
    @EnvironmentObject var vm: PhotoListViewModelImpl
    let photo: PhotoResponse
    let image: UIImage
    let photoInfo: PhotoInfo?
    let photoID: String
    let router: AppRouter
    
    var body: some View {
        
        if let photoInfo = photoInfo {
            
            VStack(alignment: .leading, spacing: nil) {
                
                NavigationLink {
                    router.navigate(to: .userPhotoGrid(userID: photoInfo.photo.owner.nsid, authorName: photoInfo.photo.owner.username, userPhotoInfo: photoInfo, photo: photo))
                } label: {
                    ImageNameHeaderView(photo: photo, photoInfo: photoInfo)

                }
                .accessibilityIdentifier(AccessibilityIdentifiers.goToUserPhotoGridButton)
                
                NavigationLink {
                    router.navigate(to: .imageDetail(photo: photo, image: image, photoInfo: photoInfo))
                } label: {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .clipped()
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.imageDetailButton)
                
                Text(photo.title)
                    .accessibilityIdentifier(AccessibilityIdentifiers.photoCardTitle)
                Text(photo.owner)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier(AccessibilityIdentifiers.photoCardOwner)
                
                
                if let tags = vm.getPhotoWithTag(photoID: photo.id), !tags.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(tags, id: \.id) { photoTag in
                                TagBody(tag: photoTag).scaledToFit()
                                    .padding(.leading, 8)
                                    .accessibilityIdentifier(AccessibilityIdentifiers.tagBody)
                            }
                        }
                    }
                }
            }
            .padding()
            
        }
    }
}

#Preview {
    PhotoCardView(photo: Mocks.samplePhotoResponse, image: UIImage(resource: .personPlaceholder), photoInfo: Mocks.samplePhotoInfo, photoID: "53964476374", router: AppRouter())
}
