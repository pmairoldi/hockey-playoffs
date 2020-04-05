//
//  TeamImage.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 12-02-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import UIKit;

@interface TeamImage : UIView

-(void)setSmallImage:(NSString *)teamABR;
-(void)setMediumImage:(NSString *)teamABR;
-(void)setLargeImage:(NSString *)teamABR;
-(void)setImageForTeam:(NSString *)teamABR andSize:(int)size;

@end
