//
//  ImageDetailView.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import SwiftUI

struct ImageDetailView: View {
    
    var photo: PhotoResponse
    var image: UIImage
    var photoInfo: PhotoInfo
    let router: AppRouter
    
    @EnvironmentObject var vm: PhotoListViewModelImpl
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    ImageNameHeaderView(photo: photo, photoInfo: photoInfo)
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .clipped()
                        .accessibilityIdentifier(AccessibilityIdentifiers.imageDetailImage)
                    Text(photo.title)
                        .font(.headline)
                        .padding(.top, 8)
                        .accessibilityIdentifier(AccessibilityIdentifiers.imageDetailTitle)
                    
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
                }.navigationTitle(photoInfo.photo.owner.username)
                    .padding(.horizontal, 8)
                    .padding(.vertical, nil)
            }
        }
        .navigationBarBackButtonHidden(false)
        
    }
}

#Preview {
    ImageDetailView(photo: Mocks.samplePhotoResponse, image: UIImage(resource: .personPlaceholder), photoInfo: Mocks.samplePhotoInfo, router: AppRouter())
}
