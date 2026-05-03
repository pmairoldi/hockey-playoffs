//
//  VideoPlayerViewController.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-30.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "HockeyPlayoffs-Swift.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

+(AVPlayerViewController *)playerWithUrl:(NSURL *)url {
    if (url != nil && [url isKindOfClass:[NSURL class]]) {
        [self setupAudioSession];
        
        AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
        
        AVPlayer *player = [AVPlayer playerWithURL:url];
        player.muted = true;
        
        [playerController setPlayer:player];
        
        [self activateAudioSession];

        [playerController.player play];
        
        return playerController;
    } else {
        [ToastHandler show:NSLocalizedString(@"error.video.title", nil)];
        return nil;
    }
}

+(void)setupAudioSession {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                            mode:AVAudioSessionModeMoviePlayback
                                         options:0
                                           error:&error];
    
    if (error) {
        DDLogError(@"Error setting category: %@", error.localizedDescription);
    }
}

+(void)activateAudioSession {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    if (error) {
        DDLogError(@"Error activating session: %@", error.localizedDescription);
    }
}

@end
