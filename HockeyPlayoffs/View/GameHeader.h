//
//  GameHeader.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-18.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import UIKit;

@class GameModel, VideoButton;

@interface GameHeader : UITableViewHeaderFooterView

@property UISegmentedControl *sectionControl;
@property (weak) VideoButton *videoButton;

+(CGFloat)height;
-(void)setGame:(GameModel *)game;

@end
