import SwiftUI
import Photos

struct AlbumDetailView: View {
    let album: (id: String, title: String, assets: [PHAsset])

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 4) {
                ForEach(album.assets, id: \.localIdentifier) { asset in
                    AssetThumbnail(asset: asset)
                }
            }
            .padding()
        }
        .navigationTitle(album.title)
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
            } else {
                Color.gray.opacity(0.2)
                ProgressView()
            }
        }
        .frame(width: 100, height: 100)
        .clipped()
        .onAppear {
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true

            PHImageManager.default().requestImage(
                for: asset,
                targetSize: CGSize(width: 300, height: 300),
                contentMode: .aspectFill,
                options: options
            ) { result, _ in
                if let result = result {
                    image = result
                }
            }
        }
    }
}
