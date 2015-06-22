//
//  TeamImage.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 12-02-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface TeamImage : UIView

-(void)setSmallImage:(NSString *)team;
-(void)setMediumImage:(NSString *)team;
-(void)setLargeImage:(NSString *)team;
-(void)setImageForTeam:(NSString *)team andSize:(int)size;

@end
