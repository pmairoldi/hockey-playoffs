//
//  ExpandedVideoView.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-28.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandedVideoView : UIView

@property UIButton *homeHighlights;
@property UIButton *awayHighlights;
@property BOOL isExpanded;

//@property UIButton *homeCondensed;
//@property UIButton *awayCondensed;

-(void)setSelected:(BOOL)animated;
-(void)setHighlighted:(BOOL)animated;

-(void)setEnabled:(NSArray *)isEnabled withHomeTeam:(NSString *)homeTeam andAwayTeam:(NSString *)awayTeam;

@end
