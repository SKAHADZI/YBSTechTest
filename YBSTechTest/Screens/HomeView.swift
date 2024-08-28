import SwiftUI

struct HomeView: View {
    
    @StateObject private var vm = PhotoListViewModelImpl()
    var userID: String?
    var authorName: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(vm.images.keys), id: \.self) { photoID in
                        if let image = vm.images[photoID],
                           let photo = vm.photos.first(where: { $0.id == photoID }),
                           let tag = vm.getPhotoWithTag(photoID: photoID),
                           let photoInfo = vm.getPhotoInfo(for: photoID)
                        {
                            PhotoCardView(photo: photo, image: image, tag: tag.tag, photoInfo: photoInfo, photoID: photoID)
                                .onAppear {
                                    if photoID == vm.photos.last?.id {
                                        vm.loadMorePhotos( userId: userID)
                                        print("last")
                                    }
                                }
                        }
                    }
                }
            }
            .navigationBarTitle(authorName != nil ? "\(authorName ?? "")'s Photos" : "Photo Gallery")
            .onAppear {
                vm.getPhotoSearch(userId: userID)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeView()
}
