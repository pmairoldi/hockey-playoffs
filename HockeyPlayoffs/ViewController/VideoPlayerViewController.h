//
//  VideoPlayerViewController.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-30.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <AVKit/AVKit.h>

@interface VideoPlayerViewController : NSObject

+(AVPlayerViewController *)playerWithUrl:(NSURL *)url;

@end
