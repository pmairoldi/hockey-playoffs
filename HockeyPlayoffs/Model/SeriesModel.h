//
//  SeriesModel.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-07.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;

@class GameObject, SeriesObject;

@interface SeriesModel : NSObject

@property BOOL isRefreshing;

+(instancetype)initWithSeries:(SeriesObject *)series;

-(NSInteger)numberOfSections;
-(NSInteger)numberOfRowsInSection:(NSInteger)section;
-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSUInteger)topWins;
-(NSUInteger)bottomWins;
-(NSString *)topTeam;
-(NSString *)bottomTeam;
-(NSArray *)getGames;
-(GameObject *)getGameAtIndex:(NSIndexPath *)indexPath;
-(NSString *)getControllerTitle;
-(BOOL)hasData;
-(BOOL)hasTeams;

-(void)refresh:(void(^)(BOOL reload))completion;

@end
