import SwiftUI
import BackgroundTasks

@main
struct PhotoClassifierApp: App {
    @StateObject private var classifier = PhotoClassifier()
    @State private var isLoading = true

    init() {
        Self.registerBackgroundTask()
    }

    var body: some Scene {
        WindowGroup {
            if isLoading {
                SplashView {
                    isLoading = false
                    scheduleBackgroundClassification()
                }
            } else {
                ContentView()
                    .environmentObject(classifier)
            }
        }
    }

    private func scheduleBackgroundClassification() {
        let request = BGProcessingTaskRequest(identifier: "com.ThirtySixDunes.PhotoClassifier.backgroundprocess")
        request.requiresExternalPower = true
        request.requiresNetworkConnectivity = false

        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ Background task scheduled.")
        } catch {
            print("❌ Failed to schedule background task: \(error.localizedDescription)")
        }
    }

    // MARK: - Static Background Task Registration
    static func registerBackgroundTask() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.ThirtySixDunes.PhotoClassifier.backgroundprocess",
            using: nil
        ) { task in
            guard let bgTask = task as? BGProcessingTask else { return }

            let classifier = PhotoClassifier()

            bgTask.expirationHandler = {
                classifier.cancelProcessing()
            }

            classifier.resumeOrStartClassification()

            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                bgTask.setTaskCompleted(success: !classifier.isProcessing)
            }

            // Reschedule
            let request = BGProcessingTaskRequest(identifier: "com.ThirtySixDunes.PhotoClassifier.backgroundprocess")
            request.requiresExternalPower = true
            request.requiresNetworkConnectivity = false
            try? BGTaskScheduler.shared.submit(request)
        }
    }
}
