import Foundation
import BackgroundTasks
import CocoaLumberjackSwift

@objc public class AppBackgroundTasks: NSObject {
    private static let kBackgroundTaskId: String = "com.peteappdesigns.hockey-playoffs-14.background-refresh"
    
    @objc public static func registerTasks() -> Void {
        let apiHandler = APIRequestHandler.shared()
        let queue = apiHandler?.queue
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: kBackgroundTaskId, using: queue) { (task) in
            if (task.identifier == kBackgroundTaskId) {
                handleAppRefreshTask(task)
            }
        }
    }
    
    @objc public static func handleAppRefreshTask(_ task: BGTask) -> Void {
        DDLogDebug("BACKGROUND: Performing background app refresh...");
        
        let refresh = APIRequestHandler.backgroundRefresh({ responseObject, error, hasNewData in
            if (error != nil) {
                task.setTaskCompleted(success: false);
                scheduleAppRefresh();
                return;
            }
            
            if (hasNewData) {
                task.setTaskCompleted(success: true);
                scheduleAppRefresh();
            }
            else {
                task.setTaskCompleted(success: false);
                scheduleAppRefresh();
            }
        });
        
        task.expirationHandler = {
            refresh?.cancel();
        }
    }
    
    @objc public static func scheduleAppRefresh() -> Void {
        let request = BGAppRefreshTaskRequest(identifier: kBackgroundTaskId);
        
        do {
            try BGTaskScheduler.shared.submit(request);
            DDLogDebug("BACKGROUND: Background refresh task scheduled.");
        } catch {
            DDLogDebug("BACKGROUND: Could not schedule app refresh: \(error)");
        }
    }
}
