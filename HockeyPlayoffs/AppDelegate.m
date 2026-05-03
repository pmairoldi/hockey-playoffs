#import "HockeyPlayoffs-Swift.h"

#import "AppDelegate.h"
#import "APIRequestHandler.h"
#import "DatabaseHandler.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [DDLog addLogger:[DDOSLogger sharedInstance]];

    [AppBackgroundTasks registerTasks];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[APIRequestHandler sharedHandler] stopSyncTimer];
    
    [DatabaseHandler closeDatabase];
}

// MARK: UISceneSession Lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName: @"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
