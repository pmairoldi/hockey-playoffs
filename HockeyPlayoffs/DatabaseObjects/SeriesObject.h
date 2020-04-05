//
//  SeriesObject.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;

@interface SeriesObject : NSObject

@property NSString *seasonID;
@property NSString *topTeam;
@property NSString *bottomTeam;
@property NSString *conference;
@property short seed;
@property short round;
@property short topWins;
@property short bottomWins;
@property BOOL hasGameToday;

-(NSString *)getSeriesID;
-(NSString *)getRelativeSeriesID;

@end
