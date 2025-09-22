import SwiftUI
import Photos

struct AlbumDetailView: View {
    let album: (id: String, title: String, assets: [PHAsset])

    private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 12) {
                    ForEach(album.assets, id: \.localIdentifier) { asset in
                        AssetThumbnail(asset: asset)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
        }
        .navigationTitle(album.title)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
    }
}

struct AssetThumbnail: View {
    let asset: PHAsset
    @State private var image: UIImage?

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .overlay(
                        LinearGradient(
                            colors: [.clear, Color.black.opacity(0.18)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            } else {
                AppTheme.surfaceBackground
                ProgressView()
                    .tint(AppTheme.primaryAccent)
            }
        }
        .frame(height: 118)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 6, y: 3)
        .onAppear(perform: loadAsset)
    }

    private func loadAsset() {
        guard image == nil else { return }
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 600, height: 600),
            contentMode: .aspectFill,
            options: options
        ) { result, _ in
            if let result = result {
                image = result
            }
        }
    }
}
