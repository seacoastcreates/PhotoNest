import SwiftUI
import Photos

struct AlbumBrowserView: View {
    @EnvironmentObject var classifier: PhotoClassifier

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(classifier.createdAlbums, id: \.id) { album in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(album.title)
                                .font(.headline)
                                .padding(.horizontal)

                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 4) {
                                ForEach(album.assets.prefix(9), id: \.localIdentifier) { asset in
                                    AssetThumbnail(asset: asset)
                                }
                            }

                            NavigationLink(destination: AlbumDetailView(album: album)) {
                                Text("View All Photos")
                                    .font(.subheadline)
                                    .padding(.horizontal)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("My Albums")
        }
    }
}
//
//  AlbumBrowserView.swift
//  PhotoClassifier
//
//  Created by Kirby Robinson on 7/10/25.
//

