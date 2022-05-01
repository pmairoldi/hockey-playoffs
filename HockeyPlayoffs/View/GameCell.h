//
//  GameCell.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-08.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import UIKit;
#import "GameOverviewView.h"

@class GameObject, VideoButton;

@interface GameCell : UITableViewCell

@property (weak) VideoButton *videoButton;
@property UIView *seperatorView;

+(CGFloat)height;
-(void)setGame:(GameObject *)game;

@end
