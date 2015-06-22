//
//  GameObject.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameObject : NSObject

@property NSString *gameID;
@property NSString *awayID;
@property NSString *homeID;
@property short homeScore;
@property short awayScore;
@property short homeShots;
@property short awayShots;
@property NSString *date;
@property NSString *time;
@property NSString *tv;
@property short period;
@property NSString *periodTime;
@property NSString *homeStatus;
@property NSString *awayStatus;
@property NSString *seasonID;
@property BOOL started;
@property BOOL finished;
@property NSString *homeHighlight;
@property NSString *awayHighlight;
@property NSString *homeCondense;
@property NSString *awayCondense;
@property BOOL active;

+(instancetype)objectFromDictionary:(NSDictionary *)dictionary;

-(NSArray *)arguments;
-(short)getScoreForTeam:(NSString *)team;
-(BOOL)hasWonGame:(NSString *)team;
-(BOOL)hasVideo;
-(NSArray *)videoLinks;
-(NSString *)getGameStatus;
-(NSArray *)getEnabledVideos;
-(NSString *)getGameText;

@end
