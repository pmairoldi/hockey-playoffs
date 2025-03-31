//
//  VideoPlayerViewController.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-30.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import AFNetworking.AFNetworkReachabilityManager;
#import "VideoPlayerViewController.h"
#import "HockeyPlayoffs-Swift.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

+(AVPlayerViewController *)playerWithUrl:(NSURL *)url {
    if (url != nil && [url isKindOfClass:[NSURL class]] && [AFNetworkReachabilityManager sharedManager].reachable) {
        
        AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
        AVPlayer *player = [AVPlayer playerWithURL:url];
        
        [playerController setPlayer:player];
        [playerController.player play];
        
        return playerController;
    } else {
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            [ToastHandler show:NSLocalizedString(@"error.video.title", nil)];
        } else {
            [ToastHandler show:NSLocalizedString(@"offline", nil)];
        }
        
        return nil;
    }
}

@end
