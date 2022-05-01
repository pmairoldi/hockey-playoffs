//
//  GameOverviewView.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-27.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import UIKit;

@class VideoButton, GameObject;

@interface GameOverviewView : UIView

@property VideoButton *videoButton;

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
-(void)setSelected:(BOOL)selected animated:(BOOL)animated;
+(CGFloat)height;
-(void)setGame:(GameObject *)game;

@end
