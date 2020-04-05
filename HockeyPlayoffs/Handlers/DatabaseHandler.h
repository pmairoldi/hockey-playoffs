//
//  DatabaseHandler.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-02.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;
@import FMDB.FMDatabase;
@import FMDB.FMDatabaseQueue;

@class SeriesObject, GameObject;

@interface DatabaseHandler : NSObject

+(FMDatabase *)getDatabase;
+(FMDatabaseQueue *)getDatabaseQueue;
+(void)closeDatabase;

+(void)updatePlayoffData:(id)data;
+(NSArray *)getPlayoffsTree;
+(SeriesObject *)getSeriesForRound:(short)round seed:(short)seed conference:(NSString *)conference seasonID:(NSString *)seasonID;
+(NSArray *)getGamesForSeries:(SeriesObject *)series;
+(GameObject *)getGameForID:(NSString *)gameID;
+(NSArray *)getPeriodsForGameID:(NSString *)gameID;
+(NSArray *)getEventsForGameID:(NSString *)gameID;
+(short)getNumberOfPeriodsForGameID:(NSString *)gameID;
+(NSArray *)getGamesForDate:(NSDate *)date;

@end
