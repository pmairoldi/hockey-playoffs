//
//  GameModel.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-09.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;

@class EventObject, GameObject;

@interface GameModel : NSObject

@property NSInteger sectionIndex;
@property GameObject *gameObject;
@property BOOL isRefreshing;

+(instancetype)initWithGame:(GameObject *)game;

-(NSUInteger)getScoreForTeam:(NSString *)team;
-(NSUInteger)getScoreForTeam:(NSString *)team inPeriod:(NSUInteger)period;
-(NSUInteger)getShotsForTeam:(NSString *)team;
-(NSUInteger)getShotsForTeam:(NSString *)team inPeriod:(NSUInteger)period;
-(BOOL)hasWonGame:(NSString *)team;
-(BOOL)isTeamHome:(NSString *)team;
-(NSInteger)numberOfSections;
-(NSInteger)numberOfRowsInSection:(NSInteger)section;
-(EventObject *)getEventAtIndex:(NSIndexPath *)indexPath;
-(NSString *)getPeriodAtIndex:(NSInteger)section;
-(NSString *)getTitle;
+(NSArray *)getSectionItems;
-(BOOL)isVideoAvailable;
-(NSURL *)getVideoLink;
-(NSString *)homeTeam;
-(NSString *)awayTeam;
-(BOOL)hasOTPeriod;
-(short)otPeriod;
-(BOOL)hasNoEventsAtIndex:(NSIndexPath *)indexPath;
-(NSString *)getNoDataText;

-(void)refresh:(void(^)(BOOL reload))completion;


@end
