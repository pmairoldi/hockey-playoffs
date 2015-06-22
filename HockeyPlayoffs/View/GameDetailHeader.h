//
//  GameDetailHeader.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-21.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameDetailHeader : UITableViewHeaderFooterView

+(CGFloat)height;
-(void)setPeriod:(NSString *)period;

@end
