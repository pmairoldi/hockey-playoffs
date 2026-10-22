import BackgroundTasks
import CocoaLumberjackSwift

@MainActor
final class AppBackgroundTasks {
    private static let identifier = "com.peteappdesigns.hockey-playoffs-14.background-refresh"

    static func registerTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: .main) { task in
            Task { @MainActor in
                task.expirationHandler = {
                    Task { @MainActor in APIRequestHandler.shared.cancelRefresh() }
                }
                let success = await APIRequestHandler.shared.refresh()
                task.setTaskCompleted(success: success)
                scheduleAppRefresh()
            }
        }
    }
    static func scheduleAppRefresh() {
        do { try BGTaskScheduler.shared.submit(BGAppRefreshTaskRequest(identifier: identifier)) } catch {
            DDLogDebug("Could not schedule background refresh: \(error)")
        }
    }
}
