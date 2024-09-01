import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var vm: PhotoListViewModelImpl
    var userID: String?
    var authorName: String?
    @State private var isSheetPresented = false
    @State private var selectedUserID: String?
    @State private var selectedAuthorName: String?
    @ObservedObject var router: AppRouter
    
    var body: some View {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(vm.photos.enumerated()), id: \.0) { index, photo in
                        let photoInfo = vm.getPhotoInfo(for: photo.id)
                        
                        if let image = vm.images[photo.id],
                           let photo = vm.photos.first(where: { $0.id == photo.id })
                        {
                            PhotoCardView(photo: photo, image: image, photoInfo: photoInfo ?? nil, photoID: photo.id, router: router)
                                .onAppear {
                                    if index == vm.photos.count - 1 {
                                        vm.loadMorePhotos( userId: userID)
                                    }
                                }
                        }
                    }
                }
                
                switch vm.viewState {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView("Loading...")
                case .success:
                    EmptyView()
                case .failure:
                    if let errorMessage = vm.errorMessage {
                        Text("\(errorMessage)")
                    }
                case .isLoadingMore:
                    ProgressView("Loading more photos...")
                case .loadedAll:
                    EmptyView()
                }
            }
            .navigationTitle("Photo Gallery")
            .onAppear {
                if !vm.dataLoaded {
                    vm.getPhotoSearch(userId: userID)
                }
            }
    }
}

#Preview {
    HomeView(router: AppRouter())
}
