//
//  AppDelegate.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2/22/2014.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import AFNetworking;
@import BackgroundTasks;
#import "AppDelegate.h"
#import "TabBarController.h"
#import "Colors.h"
#import "APIRequestHandler.h"
#import "DatabaseHandler.h"

#define kBackgroundTaskId @"com.peteappdesigns.hockey-playoffs-14.background-refresh"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DDLog addLogger:[DDOSLogger sharedInstance]];

    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:[self reachabilityChanged]];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    [[BGTaskScheduler sharedScheduler]
     registerForTaskWithIdentifier:kBackgroundTaskId
     usingQueue: [[APIRequestHandler sharedHandler] queue]
     launchHandler:^(__kindof BGTask * _Nonnull task) {
        [self handleAppRefreshTask:(BGAppRefreshTask *)task];
    }];
                
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    _rootViewController = [[TabBarController alloc] init];
    self.window.rootViewController = _rootViewController;
    
    self.window.backgroundColor = [Colors backgroundColor];
    self.window.tintColor = [Colors tintColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    [[APIRequestHandler sharedHandler] stopSyncTimer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self scheduleAppRefresh];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [[APIRequestHandler sharedHandler] startSyncTimer];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[APIRequestHandler sharedHandler] stopSyncTimer];
    
    [DatabaseHandler closeDatabase];
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
