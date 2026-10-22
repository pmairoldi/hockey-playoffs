import CocoaLumberjackSwift
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        DDLog.add(DDOSLogger.sharedInstance)
        AppBackgroundTasks.registerTasks()
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        APIRequestHandler.shared.stopSyncTimer()
        DatabaseHandler.shared.close()
    }
    func application(
        _ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(
            name: "Default Configuration", sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}

@objc(SceneDelegate)
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: scene)
        window.rootViewController = TabBarController()
        window.backgroundColor = Colors.backgroundColor()
        window.tintColor = Colors.tintColor()
        self.window = window
        window.makeKeyAndVisible()
    }
    func sceneDidBecomeActive(_ scene: UIScene) { APIRequestHandler.shared.startSyncTimer() }
    func sceneWillResignActive(_ scene: UIScene) { APIRequestHandler.shared.stopSyncTimer() }
    func sceneDidEnterBackground(_ scene: UIScene) { AppBackgroundTasks.scheduleAppRefresh() }
}
