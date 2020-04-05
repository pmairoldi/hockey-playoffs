//
//  PeriodScoresView.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-22.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import UIKit;

@class GameModel;

@interface PeriodScoresView : UIView

-(void)setScores:(GameModel *)game ForTeam:(NSString *)team;

@end
