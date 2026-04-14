@import BackgroundTasks;
@import AFNetworking;
#import "SceneDelegate.h"
#import "TabBarController.h"
#import "Colors.h"
#import "APIRequestHandler.h"
#import "DatabaseHandler.h"

#define kBackgroundTaskId @"com.peteappdesigns.hockey-playoffs-14.background-refresh"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:[self reachabilityChanged]];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[BGTaskScheduler sharedScheduler]
     registerForTaskWithIdentifier:kBackgroundTaskId
     usingQueue: [[APIRequestHandler sharedHandler] queue]
     launchHandler:^(__kindof BGTask * _Nonnull task) {
        [self handleAppRefreshTask:(BGAppRefreshTask *)task];
    }];
    
    
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene*)scene];
    
    self.window.rootViewController = [[TabBarController alloc] init];
    self.window.backgroundColor = [Colors backgroundColor];
    self.window.tintColor = [Colors tintColor];
    
    [self.window makeKeyAndVisible];
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    [[APIRequestHandler sharedHandler] stopSyncTimer];
    
    [DatabaseHandler closeDatabase];
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    [[APIRequestHandler sharedHandler] startSyncTimer];
}

- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    [[APIRequestHandler sharedHandler] stopSyncTimer];
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    [self scheduleAppRefresh];
}

# pragma background refresh

- (void)handleAppRefreshTask:(BGAppRefreshTask *)task {
    DDLogDebug(@"BACKGROUND: Performing background app refresh...");
    
    NSURLSessionDataTask *refresh = [APIRequestHandler backgroundRefresh:^(id responseObject, NSError *error, BOOL hasNewData) {
        if (error) {
            [task setTaskCompletedWithSuccess:false];
            [self scheduleAppRefresh];
            return;
        }
        
        if (hasNewData) {
            [task setTaskCompletedWithSuccess:true];
            [self scheduleAppRefresh];
        }
        else {
            [task setTaskCompletedWithSuccess:false];
            [self scheduleAppRefresh];
        }
    }];
    
    task.expirationHandler = ^{
        [refresh cancel];
    };
}

- (void)scheduleAppRefresh {
    BGAppRefreshTaskRequest *request = [[BGAppRefreshTaskRequest alloc] initWithIdentifier: kBackgroundTaskId];
    
    NSError *error = nil;
    if (![[BGTaskScheduler sharedScheduler] submitTaskRequest:request error:&error]) {
        DDLogDebug(@"BACKGROUND: Could not schedule app refresh: %@", error);
    } else {
        DDLogDebug(@"BACKGROUND: Background refresh task scheduled.");
    }
}

-(void (^)(AFNetworkReachabilityStatus status))reachabilityChanged {
    
    return ^(AFNetworkReachabilityStatus status) {
        DDLogDebug(@"reachable %d", [AFNetworkReachabilityManager sharedManager].reachable);
    };
}

@end
