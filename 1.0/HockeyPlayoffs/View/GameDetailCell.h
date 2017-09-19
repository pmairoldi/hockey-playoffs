//
//  GameDetailCell.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-18.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventObject;

@interface GameDetailCell : UITableViewCell

@property UIView *seperatorView;

+(CGFloat)height;
-(void)setEvent:(EventObject *)event;

@end
