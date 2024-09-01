//
//  UserPhotoGridView.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 29/08/2024.
//

import SwiftUI
import UIKit

struct UserPhotoGridView: View {
    
    let userID: String
    let authorName: String
    var userPhotoInfo: PhotoInfo
    var photo: Photo
    
    @StateObject private var vm = PhotoListViewModelImpl()
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                ProfileDetailHeaderView(photo: photo, photoInfo: userPhotoInfo)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(Array(vm.photos.enumerated()), id: \.element.id) { index, photo in
                        if let image = vm.images[photo.id],
                           let photoInfo = vm.getPhotoInfo(for: photo.id) {
                            NavigationLink(destination: ImageDetailView(photo: photo, image: image, photoInfo: photoInfo)) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width / 3 - 20, height: UIScreen.main.bounds.width / 3 - 20)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                            .onAppear {
                                if index == vm.photos.count - 1 {
                                    // Trigger loading more photos when the last item appears
                                    vm.loadMorePhotos(userId: userID)
                                }
                            }
                            
                        }
                    }
                }
            }
            .padding()
            switch vm.viewState {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView("Loading...")
            case .success:
                EmptyView()
            case .failure(let error):
                if let errorMessage = vm.errorMessage {
                    Text("\(errorMessage)")
                }
            case .isLoadingMore:
                ProgressView("Loading more photos...")
            case .loadedAll:
                EmptyView()
            }
        }
        .navigationTitle("\(authorName)'s Photos")
        .onAppear {
            vm.getPhotoSearch(userId: userID)
        }
    }
}

//#Preview {
//    UserPhotoGridView(userID: "12345", authorName: "Sample Author")
//}
