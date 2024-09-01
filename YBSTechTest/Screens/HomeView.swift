import SwiftUI

struct HomeView: View {
    
    @StateObject var vm = PhotoListViewModelImpl()
    var userID: String?
    var authorName: String?
    @State private var isSheetPresented = false
    @State private var selectedUserID: String?
    @State private var selectedAuthorName: String?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(vm.photos.enumerated()), id: \.element.id) { index, photo in
                        let _ = print("index = \(index)")
                        let photoInfo = vm.getPhotoInfo(for: photo.id)

                        if let image = vm.images[photo.id],
                           let photo = vm.photos.first(where: { $0.id == photo.id })
                        {
                            PhotoCardView(photo: photo, image: image, photoInfo: photoInfo ?? nil, photoID: photo.id)
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
            .navigationTitle("Photo Gallery")
            .onAppear {
                if !vm.dataLoaded {
                    vm.getPhotoSearch(userId: userID) // Load data only if not already loaded
                }
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeView()
}
