import SwiftUI

struct HomeView: View {
    
    @StateObject private var vm = PhotoListViewModelImpl()
    var userID: String?
    var authorName: String?
    @State private var isSheetPresented = false
    @State private var selectedUserID: String?
    @State private var selectedAuthorName: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                switch vm.state {
                case .idle:
                    Text("Welcome! Just getting ready :)")
                case .loading:
                    Spacer()
                    ProgressView("Loading...")
                case .success:
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(vm.photos.enumerated()), id: \.element.id) { index, photo in
                            if let image = vm.images[photo.id],
                               let photo = vm.photos.first(where: { $0.id == photo.id }),
                               let tag = vm.getPhotoWithTag(photoID: photo.id),
                               let photoInfo = vm.getPhotoInfo(for: photo.id)
                            {
                                PhotoCardView(photo: photo, image: image, tag: tag.tag, photoInfo: photoInfo, photoID: photo.id)
                                    .onAppear {
                                        if index == vm.photos.count - 1 {
                                            vm.loadMorePhotos( userId: userID)
                                            print("last")
                                        }
                                    }
                            }
                        }
                    }
                case .failure(let error):
                    Text("An Error occured: \(error.localizedDescription)")
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
