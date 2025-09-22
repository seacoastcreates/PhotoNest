import SwiftUI

struct ContentView: View {
    @EnvironmentObject var classifier: PhotoClassifier
    @AppStorage("clusterCount") private var clusterCount: Double = 5.0
    @State private var showingPhotosPrompt = false
    @State private var navigateToAlbumBrowser = false
    @State private var startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate = Date()
    @State private var datesInitialized = false

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            NavigationStack {
                ScrollView {
                    VStack(spacing: 28) {
                        headerSection
                        clusterSection
                        dateSection
                        statusSection
                        actionSection
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 36)
                }
                .scrollIndicators(.hidden)
                .navigationDestination(isPresented: $navigateToAlbumBrowser) {
                    AlbumBrowserView()
                        .environmentObject(classifier)
                }
                .toolbarBackground(.hidden, for: .navigationBar)
            }
        }
        .onAppear(perform: initializeDates)
        .onChange(of: startDate) { _, newValue in
            if newValue > endDate {
                endDate = newValue
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

    private var headerSection: some View {
        VStack(spacing: 16) {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 140)
                .shadow(radius: 12)

            Text("PhotoNester")
                .font(AppTheme.titleFont(34))
                .foregroundStyle(.white)

            Text("Organize memories into smart nests with a single tap.")
                .font(AppTheme.bodyFont())
                .foregroundStyle(Color.white.opacity(0.75))
                .multilineTextAlignment(.center)
        }
        .glassCardStyle()
    }

    private var clusterSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .firstTextBaseline) {
                Text("Number of Nests")
                    .font(AppTheme.titleFont(20))
                    .foregroundStyle(.white)
                Spacer()
                Text("\(Int(clusterCount))")
                    .font(AppTheme.titleFont(22))
                    .foregroundStyle(AppTheme.primaryAccent)
            }

            Slider(value: $clusterCount, in: 2...10, step: 1)
                .tint(AppTheme.primaryAccent)

            Text("Tip: Start with 5 nests to see balanced clusters.")
                .font(AppTheme.bodyFont())
                .foregroundStyle(Color.white.opacity(0.7))
        }
        .glassCardStyle()
    }

    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Date Range")
                .font(AppTheme.titleFont(20))
                .foregroundStyle(.white)

            VStack(spacing: 12) {
                dateField(title: "From", binding: $startDate, minimum: nil, maximum: endDate)
                dateField(title: "To", binding: $endDate, minimum: startDate, maximum: Date())
            }

            Text("Only photos captured within this window will be classified.")
                .font(AppTheme.bodyFont())
                .foregroundStyle(Color.white.opacity(0.7))
        }
        .glassCardStyle()
    }

    private func dateField(title: String, binding: Binding<Date>, minimum: Date?, maximum: Date?) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(AppTheme.bodyFont(13))
                .foregroundStyle(Color.white.opacity(0.6))

            DatePicker(
                "",
                selection: binding,
                in: (minimum ?? Date.distantPast)...(maximum ?? Date.distantFuture),
                displayedComponents: [.date]
            )
            .labelsHidden()
            .datePickerStyle(.compact)
            .tint(AppTheme.primaryAccent)
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(AppTheme.surfaceBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    private var statusSection: some View {
        Group {
            if classifier.isSavingAlbums {
                VStack(spacing: 14) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(AppTheme.primaryAccent)
                    Text(classifier.estimatedSaveTimeText)
                        .font(AppTheme.bodyFont())
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white.opacity(0.85))
                }
                .glassCardStyle()
            } else if classifier.isProcessing {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Processing \(classifier.processedCount) of \(classifier.totalToProcess)")
                        .font(AppTheme.bodyFont())
                        .foregroundStyle(Color.white.opacity(0.8))

                    ProgressView(value: classifier.progress)
                        .tint(AppTheme.primaryAccent)
                        .padding(.top, 6)

                    Button("Cancel") {
                        classifier.cancelProcessing()
                    }
                    .buttonStyle(DestructiveButtonStyle())
                }
                .glassCardStyle()
            } else if classifier.progress >= 1.0 {
                Text("Nesting complete — your new albums are ready!")
                    .font(AppTheme.bodyFont(18))
                    .foregroundStyle(Color.green.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .glassCardStyle()
            }
        }
    }

    private var actionSection: some View {
        Group {
            if !classifier.isProcessing && !classifier.isSavingAlbums {
                Button {
                    print("🟢 Classify button tapped")
                    classifier.resumeOrStartClassification(startDate: startDate, endDate: endDate)
                } label: {
                    Text("Classify Photos")
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }

    private func initializeDates() {
        guard !datesInitialized else { return }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if let storedStart = classifier.selectedStartDate {
            startDate = calendar.startOfDay(for: storedStart)
        } else {
            startDate = calendar.date(byAdding: .month, value: -1, to: today) ?? today
        }
        if let storedEnd = classifier.selectedEndDate {
            endDate = calendar.startOfDay(for: storedEnd)
        } else {
            endDate = today
        }
        if endDate < startDate {
            endDate = startDate
        }
        datesInitialized = true
    }
}

extension Notification.Name {
    static let promptToOpenPhotos = Notification.Name("promptToOpenPhotos")
}
