//
//  VideoPlayerViewController.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-30.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <CRToast/CRToast.h>
#import "Animations.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

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
            [self showNotificationWithTitle:NSLocalizedString(@"error.video.title", nil)];
        } else {
            [self showNotificationWithTitle:NSLocalizedString(@"offline", nil)];
        }
        
        return nil;
    }
}

+(void)showNotificationWithTitle:(NSString *)title {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *options = @{
                                  kCRToastTextKey : title,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastNotificationPresentationTypeKey: @(CRToastPresentationTypeCover),
                                  kCRToastNotificationTypeKey : @(CRToastTypeStatusBar),
                                  kCRToastTimeIntervalKey : @(kAnimationDuration),
                                  kCRToastStatusBarStyleKey : @([[UIApplication sharedApplication] statusBarStyle]),
                                  kCRToastAllowDuplicatesKey : @(NO)
                                  };
        
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
    });
}

@end
