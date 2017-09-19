//
//  VideoPlayerViewController.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-30.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerViewController : MPMoviePlayerViewController

+(void)showNotificationWithTitle:(NSString *)title;
+(void)showVideo:(NSURL *)url inController:(UIViewController *)controller;

@end
