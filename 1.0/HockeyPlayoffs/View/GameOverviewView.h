//
//  GameOverviewView.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-27.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoButton, GameObject, ExpandedVideoView;

@interface GameOverviewView : UIView

@property VideoButton *videoButton;
//@property ExpandedVideoView *videoView;

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
-(void)setSelected:(BOOL)selected animated:(BOOL)animated;
+(CGFloat)height;
-(void)setGame:(GameObject *)game;
//-(void)isExpanded:(int)expandedIndex;

@end
