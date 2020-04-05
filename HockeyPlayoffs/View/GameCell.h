//
//  GameCell.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-08.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import UIKit;
#import "GameOverviewView.h"

@class GameObject, VideoButton, ExpandedVideoView;

@interface GameCell : UITableViewCell

@property (weak) VideoButton *videoButton;
@property (weak) ExpandedVideoView *videoView;
@property UIView *seperatorView;

+(CGFloat)height;
-(void)setGame:(GameObject *)game;
//-(void)isExpanded:(int)expandedIndex;

@end
