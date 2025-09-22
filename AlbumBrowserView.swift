import SwiftUI
import Photos

struct AlbumBrowserView: View {
    @EnvironmentObject var classifier: PhotoClassifier

    private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 8, alignment: .top), count: 3)

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            NavigationStack {
                ScrollView {
                    LazyVStack(spacing: 24) {
                        ForEach(classifier.createdAlbums, id: \.id) { album in
                            albumCard(for: album)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 28)
                }
                .scrollIndicators(.hidden)
                .navigationTitle("My Albums")
                .toolbarBackground(.hidden, for: .navigationBar)
                .toolbarTitleDisplayMode(.inline)
            }
        }
    }

    private func albumCard(for album: (id: String, title: String, assets: [PHAsset])) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline) {
                Text(album.title)
                    .font(AppTheme.titleFont(22))
                    .foregroundStyle(.white)
                Spacer()
                Text("\(album.assets.count) photos")
                    .font(AppTheme.bodyFont(15))
                    .foregroundStyle(Color.white.opacity(0.7))
            }

            LazyVGrid(columns: gridColumns, spacing: 8) {
                ForEach(album.assets.prefix(9), id: \.localIdentifier) { asset in
                    AssetThumbnail(asset: asset)
                }
            }

            NavigationLink {
                AlbumDetailView(album: album)
            } label: {
                HStack {
                    Text("View All Photos")
                        .font(AppTheme.bodyFont(17))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(AppTheme.primaryAccent)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(AppTheme.surfaceBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .glassCardStyle()
    }
}
//
//  AlbumBrowserView.swift
//  PhotoClassifier
//
//  Created by Kirby Robinson on 7/10/25.
//
