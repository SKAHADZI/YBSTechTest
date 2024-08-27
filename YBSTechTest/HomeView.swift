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
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(vm.images, id: \.1.uuid) { (image,photo) in
                        NavigationLink("Go to group 2") {
                            Text("Go to group 2")
                        }
                        Group {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 500, height: 500)
                            Text(photo.owner)
                        }
                    }
                }
            }
            .onAppear {
                vm.getPhotoSearch()
            }
        }
    }
}

#Preview {
    HomeView()
}
