//
//  HomeView.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 26/08/2024.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm = PhotoListViewModelImpl()
    var body: some View {
        VStack {

            ScrollView {
                if let photoDetail = vm.photos?.photos.photo {
                    ForEach(photoDetail, id: \.uuid) { photo in
                        Text(photo.owner)
                        AsyncImage(url: vm.buildImageURL(photo: photo))
                            .frame(width: 500, height: 500)
                    }
                }

            }
        }
        .onAppear {
            vm.getPhotoSearch()
        }
    }
}

#Preview {
    HomeView()
}
