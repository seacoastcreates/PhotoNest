import SwiftUI

struct ContentView: View {
    @EnvironmentObject var classifier: PhotoClassifier
    @AppStorage("clusterCount") private var clusterCount: Double = 5.0
    @State private var showingPhotosPrompt = false
    @State private var navigateToAlbumBrowser = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 240)
                    .padding(.bottom)

                Text("PhotoNester")
                    .font(.custom("Montserrat-SemiBold", size: 36))

                VStack(alignment: .leading) {
                    Text("Number of Nests: \(Int(clusterCount))")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                    Slider(value: $clusterCount, in: 2...10, step: 1)
                    Text("5 is a good starting point.")
                        .font(.system(size: 16))
                }
                .padding()

                if classifier.isSavingAlbums {
                    VStack(spacing: 10) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text(classifier.estimatedSaveTimeText)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else if classifier.isProcessing {
                    VStack(spacing: 16) {
                        Text("Processed \(classifier.processedCount)/\(classifier.totalToProcess)")
                            .font(.subheadline)
                        ProgressView(value: classifier.progress)
                            .progressViewStyle(LinearProgressViewStyle())
                            .padding()
                        Button(action: {
                            classifier.cancelProcessing()
                        }) {
                            Text("Cancel")
                                .font(.headline)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                } else if classifier.progress >= 1.0 {
                    Text("✅ Nesting complete")
                        .font(.title2)
                        .foregroundColor(.green)
                } else {
                    Button(action: {
                        print("🟢 Classify button tapped")
                        classifier.resumeOrStartClassification()
                    }) {
                        Text("Classify Photos")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .navigationDestination(isPresented: $navigateToAlbumBrowser) {
                    AlbumBrowserView()
                        .environmentObject(classifier)
                }
        }
        .onReceive(NotificationCenter.default.publisher(for: .promptToOpenPhotos)) { _ in
            showingPhotosPrompt = true
        }
        .alert("Albums Created", isPresented: $showingPhotosPrompt) {
            Button("View Albums") {
                navigateToAlbumBrowser = true
            }
            Button("Dismiss", role: .cancel) { }
        } message: {
            Text("Your nested albums are ready. Would you like to browse them in PhotoNester?")
        }
    }
}

extension Notification.Name {
    static let promptToOpenPhotos = Notification.Name("promptToOpenPhotos")
}
