//
//  DatabaseHandler.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-02.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "DatabaseHandler.h"
#import "FileHandler.h"
#import "GameObject.h"
#import "PeriodObject.h"
#import "TeamObject.h"
#import "APIIdentifiers.h"
#import "Notifications.h"
#import "SeriesObject.h"
#import "EventObject.h"
#import "Queues.h"
#import "DateTimeHandler.h"

#define DATABASE_FILE_NAME @"hockey.sqlite"

@interface DatabaseHandler ()

@property FMDatabase *database;
@property FMDatabaseQueue *databaseQueue;

@end

@implementation DatabaseHandler

+(instancetype)sharedHandler {
    
    static DatabaseHandler *sharedHandler = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedHandler = [[self alloc] init];
    });
    
    return sharedHandler;
}

+(FMDatabase *)getDatabase {
    
    DatabaseHandler *handler = [[self class] sharedHandler];
    
    if ([handler database] == nil) {
        
        NSString *documentsDirectoryPath = [FileHandler getLibraryDirectoryPathForFile:DATABASE_FILE_NAME];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:documentsDirectoryPath] == NO) {
            
            NSString *bundlePath = [FileHandler getBundlePathForFile:DATABASE_FILE_NAME];
            
            NSError *error;
            
            [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:documentsDirectoryPath error:&error];
            
            if (error != nil) {
                NSCAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            }
        }
        
        handler.database = [FMDatabase databaseWithPath:documentsDirectoryPath];
    }
    
    if (![handler.database open]) {
        NSCAssert(0, @"Failed to open database");
    }
    
    return handler.database;
}

+(FMDatabaseQueue *)getDatabaseQueue {
    
    DatabaseHandler *handler = [[self class] sharedHandler];
    
    if ([handler databaseQueue] == nil) {
        
        NSString *documentsDirectoryPath = [FileHandler getLibraryDirectoryPathForFile:DATABASE_FILE_NAME];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:documentsDirectoryPath] == NO) {
            
            NSString *bundlePath = [FileHandler getBundlePathForFile:DATABASE_FILE_NAME];
            
            NSError *error;
            
            [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:documentsDirectoryPath error:&error];
            
            if (error != nil) {
                NSCAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            }
        }
        
        handler.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:documentsDirectoryPath];
    }
    
    return handler.databaseQueue;
}

+(void)closeDatabase {
    
    DatabaseHandler *handler = [[self class] sharedHandler];
    
    if ([handler database] != nil) {
        
        if (![handler.database close]) {
            NSCAssert(0, @"Failed to close database");
        }
    }
    
    if ([handler databaseQueue] != nil) {
        
        [handler.databaseQueue close];
    }
}

+(void)updatePlayoffData:(id)data {
    
    dispatch_async(DB_SAVE_QUEUE, ^{
        
        FMDatabaseQueue *databaseQueue = [[self class] getDatabaseQueue];
        
        NSMutableArray *gamesToInsert = [[NSMutableArray alloc] init];
        NSMutableArray *periodsToInsert = [[NSMutableArray alloc] init];
        NSMutableArray *teamsToInsert = [[NSMutableArray alloc] init];
        NSMutableArray *eventsToInsert = [[NSMutableArray alloc] init];
        NSMutableArray *eventsIds = [[NSMutableArray alloc] init];
        
        NSDictionary *playoffData = (NSDictionary *)data;
        
        if ([[playoffData allKeys] containsObject:kGamesJSONKey]) {
            
            NSArray *games = [playoffData objectForKey:kGamesJSONKey];
            
            for (NSDictionary *dictionary in games) {
                
                GameObject *game = [GameObject objectFromDictionary:dictionary];
                
                [gamesToInsert addObject:game];
            }
        }
        
        if ([[playoffData allKeys] containsObject:kPeriodsJSONKey]) {
            
            NSArray *periods = [playoffData objectForKey:kPeriodsJSONKey];
            
            for (NSDictionary *dictionary in periods) {
                
                PeriodObject *period = [PeriodObject objectFromDictionary:dictionary];
                
                [periodsToInsert addObject:period];
            }
        }
        
        if ([[playoffData allKeys] containsObject:kTeamsJSONKey]) {
            
            NSArray *teams = [playoffData objectForKey:kTeamsJSONKey];
            
            for (NSDictionary *dictionary in teams) {
                
                TeamObject *team = [TeamObject objectFromDictionary:dictionary];
                
                [teamsToInsert addObject:team];
            }
        }
        
        if ([[playoffData allKeys] containsObject:kEventsJSONKey]) {
            
            NSArray *events = [playoffData objectForKey:kEventsJSONKey];
            
            for (NSDictionary *dictionary in events) {
                
                EventObject *event = [EventObject objectFromDictionary:dictionary];
                
                [eventsToInsert addObject:event];
                [eventsIds addObject:event.gameID];
            }
        }
        
        [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            for (GameObject *game in gamesToInsert) {
                
                if (game.active) {
                    [db executeUpdate:@"INSERT OR REPLACE INTO games (game_id,away_id,home_id,date,time,tv,period,period_time,home_status,away_status,season_id,started,finished,home_highlight,away_highlight,home_condense,away_condense) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:[game arguments]];
                }
                
                else {
                    [db executeUpdate:@"DELETE FROM games WHERE game_id = ?" withArgumentsInArray:@[game.gameID]];
                }
            }
            
            for (PeriodObject *period in periodsToInsert) {
                
                [db executeUpdate:@"INSERT OR REPLACE INTO periods (game_id,team_id,period,shots,goals) VALUES (?,?,?,?,?)" withArgumentsInArray:[period arguments]];
            }
            
            for (TeamObject *team in teamsToInsert) {
                
                [db executeUpdate:@"INSERT OR REPLACE INTO playoff_seeds (season_id,home_id,away_id,conference,round,seed) VALUES (?,?,?,?,?,?)" withArgumentsInArray:[team arguments]];
            }
            
            if (eventsIds.count > 0) {
                [db executeUpdate:@"DELETE FROM events WHERE game_id NOT IN (?)" withArgumentsInArray:@[[eventsIds componentsJoinedByString:@", "]]];
            }
            
            for (EventObject *event in eventsToInsert) {
                
                [db executeUpdate:@"INSERT OR REPLACE INTO events (id, game_id, team_id, period, time, type, description, video_link, formal_id, strength) VALUES (?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:[event arguments]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatePlayoffs object:nil];
            });
        }];
    });
}

+(NSArray *)getPlayoffsTree {
    
    //array of SeriesObject
    __block NSArray *array;
    
    FMDatabaseQueue *databaseQueue = [[self class] getDatabaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *teams = [[NSMutableArray alloc] init];
        
        //get all teams
        
        NSString *seasonID = @"";
        
        FMResultSet *result = [db executeQuery:@"SELECT MAX(season_id) AS season_id FROM playoff_seeds"];
        
        while ([result next]) {
            
            seasonID = [result stringForColumn:@"season_id"];
        }
        
        if (seasonID.length == 0) {
            
            seasonID = @"";
        }
        
        [result close];
        
        short round = 1;
        short seed = 1;
        NSString *conference = @"e";
        
        for (int i = 0; i < 15; ++i) {
            
            SeriesObject *object = [[SeriesObject alloc] init];
            
            object.seasonID = seasonID;
            object.conference = conference;
            object.round = round;
            object.seed = seed;
            
            [teams addObject:[[self class] getSeries:object inDB:db]];
            
            if (i >= 0 && i < 8) {
                //round 1
                
                if (i == 3) {
                    conference = @"w";
                    seed = 1;
                }
                
                else if (i == 7) {
                    round += 1;
                    conference = @"e";
                    seed = 1;
                }
                
                else {
                    seed += 1;
                }
            }
            
            else if (i >= 8 && i < 12) {
                //round 2
                
                if (i == 9) {
                    conference = @"w";
                    seed = 1;
                }
                
                else if (i == 11) {
                    round += 1;
                    conference = @"e";
                    seed = 1;
                }
                
                else {
                    seed += 1;
                }
            }
            
            else if (i >= 12 && i < 14) {
                //round 3
                
                if (i == 12) {
                    conference = @"w";
                    seed = 1;
                }
                
                else if (i == 13) {
                    round += 1;
                    conference = @"f";
                    seed = 1;
                }
                
                else {
                    seed += 1;
                }
            }
            
            else {
                
                conference = @"";
                seed = 0;
                round = 0;
            }
        }
        
        array = teams;
    }];
    
    return array;
}

+(SeriesObject *)getSeriesForRound:(short)round seed:(short)seed conference:(NSString *)conference seasonID:(NSString *)seasonID {
    
    __block SeriesObject *object = [[SeriesObject alloc] init];
    
    FMDatabaseQueue *databaseQueue = [[self class] getDatabaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db) {
        
        object.round = round;
        object.seed = seed;
        object.conference = conference;
        object.seasonID = seasonID;
        
        object = [[self class] getSeries:object inDB:db];
        
    }];
    
    return object;
}

+(SeriesObject *)getSeries:(SeriesObject *)object inDB:(FMDatabase *)db {
    
    NSString *likeString = [object getSeriesID];
    
    NSString *currentDate = [DateTimeHandler getStringForDate:[DateTimeHandler now]];
    
    FMResultSet *series = [db executeQuery: @"SELECT t1.season_id AS season_id, CASE WHEN t1.home_id = '' THEN t2.home_id ELSE t1.home_id END AS home_id, CASE WHEN t1.away_id = '' THEN t2.away_id ELSE t1.away_id END AS away_id, conference, round, seed, isToday FROM (SELECT * FROM playoff_seeds WHERE round = ? AND seed = ? AND conference = ? AND season_id = ?) AS t1 LEFT JOIN (SELECT season_id, away_id, home_id FROM games WHERE game_id LIKE ? LIMIT 1) AS t2 ON t1.season_id = t2.season_id LEFT JOIN (SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS isToday, season_id, period_time FROM games WHERE game_id LIKE ? AND date <= ? AND period_time <> ? LIMIT 1) AS t3 ON t1.season_id = t3.season_id" withArgumentsInArray:@[@(object.round), @(object.seed), object.conference, object.seasonID, likeString, likeString, currentDate, @"FINAL"]];
    
    if ([series next]) {
        
        object.seasonID = [series stringForColumn:@"season_id"];
        
        object.topTeam = [series stringForColumn:@"home_id"];
        
        if (object.topTeam.length == 0) {
            object.topTeam = @"";
        }
        
        object.bottomTeam = [series stringForColumn:@"away_id"];
        
        if (object.bottomTeam.length == 0) {
            object.bottomTeam = @"";
        }
        
        object.conference = [series stringForColumn:@"conference"];
        object.round = (short)[series intForColumn:@"round"];
        object.seed = (short)[series intForColumn:@"seed"];
        object.hasGameToday = [series boolForColumn:@"isToday"];
    }
    
    [series close];
    
    [[self class] getWinsForSeries:object inDB:db];
    
    return object;
}

+(NSArray *)getGamesForSeries:(SeriesObject *)series {
    
    __block NSArray *array = [NSArray array];
    
    FMDatabaseQueue *databaseQueue = [[self class] getDatabaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString *likeString = [series getSeriesID];
        
        FMResultSet *games = [db executeQuery:@"SELECT * FROM games WHERE game_id LIKE ? ORDER BY game_id ASC" withArgumentsInArray:@[likeString]];
        
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        
        while ([games next]) {
            
            GameObject *game = [[GameObject alloc] init];
            
            game.gameID = [games stringForColumn:@"game_id"];
            game.awayID = [games stringForColumn:@"away_id"];
            game.homeID = [games stringForColumn:@"home_id"];
            game.date = [games stringForColumn:@"date"];
            game.time = [games stringForColumn:@"time"];
            game.tv = [games stringForColumn:@"tv"];
            game.periodTime = [games stringForColumn:@"period_time"];
            game.period = (short)[games intForColumn:@"period"];
            game.homeStatus = [games stringForColumn:@"home_status"];
            game.awayStatus = [games stringForColumn:@"away_status"];
            game.seasonID = [games stringForColumn:@"season_id"];
            game.started = [games boolForColumn:@"started"];
            game.finished = [games boolForColumn:@"finished"];
            game.homeHighlight = [games stringForColumn:@"home_highlight"];
            game.awayHighlight = [games stringForColumn:@"away_highlight"];
            game.homeCondense = [games stringForColumn:@"home_condense"];
            game.awayCondense = [games stringForColumn:@"away_condense"];
            
            [temp addObject:game];
        }
        
        [games close];
        
        for (GameObject *object in temp) {
            
            [[self class] getScoreAndShotsForGame:object inDB:db];
        }
        
        array = temp;
    }];
    
    return array;
}

+(void)getWinsForSeries:(SeriesObject *)series inDB:(FMDatabase *)db {
    
    NSString *likeString = [series getSeriesID];
    
    FMResultSet *wins = [db executeQuery:@"SELECT SUM(CASE WHEN home_id = ? THEN CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END ELSE CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END END) AS top_team, SUM(CASE WHEN home_id = ? THEN CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END ELSE CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END END) AS bottom_team FROM (SELECT t1.game_id, home_id, a.goals AS home_goals, away_id, b.goals AS away_goals FROM (SELECT game_id, home_id, away_id FROM games WHERE game_id LIKE ? AND period_time = ?) AS t1 JOIN (SELECT game_id, team_id, sum(goals) as goals FROM periods GROUP BY game_id, team_id) a ON a.game_id = t1.game_id AND a.team_id = t1.home_id JOIN (SELECT game_id, team_id, sum(goals) as goals FROM periods GROUP BY game_id, team_id) b ON b.game_id = t1.game_id AND b.team_id = t1.away_id GROUP BY t1.game_id)" withArgumentsInArray:@[series.topTeam, series.bottomTeam, likeString, @"FINAL"]];
    
    if ([wins next]) {
        series.topWins = (short)[wins intForColumn:@"top_team"];
        series.bottomWins = (short)[wins intForColumn:@"bottom_team"];
    }
    
    [wins close];
}

+(GameObject *)getGameForID:(NSString *)gameID {
    
    __block GameObject *game = [[GameObject alloc] init];
    
    FMDatabaseQueue *databaseQueue = [[self class] getDatabaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *games = [db executeQuery:@"SELECT * FROM games WHERE game_id = ?" withArgumentsInArray:@[gameID]];
        
        if ([games next]) {
            
            game.gameID = [games stringForColumn:@"game_id"];
            game.awayID = [games stringForColumn:@"away_id"];
            game.homeID = [games stringForColumn:@"home_id"];
            game.date = [games stringForColumn:@"date"];
            game.time = [games stringForColumn:@"time"];
            game.tv = [games stringForColumn:@"tv"];
            game.periodTime = [games stringForColumn:@"period_time"];
            game.period = (short)[games intForColumn:@"period"];
            game.homeStatus = [games stringForColumn:@"home_status"];
            game.awayStatus = [games stringForColumn:@"away_status"];
            game.seasonID = [games stringForColumn:@"season_id"];
            game.started = [games boolForColumn:@"started"];
            game.finished = [games boolForColumn:@"finished"];
            game.homeHighlight = [games stringForColumn:@"home_highlight"];
            game.awayHighlight = [games stringForColumn:@"away_highlight"];
            game.homeCondense = [games stringForColumn:@"home_condense"];
            game.awayCondense = [games stringForColumn:@"away_condense"];
        }
        
        [games close];
        
        [[self class] getScoreAndShotsForGame:game inDB:db];
        
    }];
    
    return game;
}

+(void)getScoreAndShotsForGame:(GameObject *)game inDB:(FMDatabase *)db {
    
    //-1 == all periods
    
    NSString *query;
    NSArray *arguements;
    
    query = @"SELECT home_shots, home_goals, away_shots, away_goals FROM (SELECT game_id, SUM(shots) AS home_shots, SUM(goals) AS home_goals FROM periods WHERE game_id = ? AND team_id = ?) AS t1 JOIN (SELECT game_id, SUM(shots) AS away_shots, SUM(goals) AS away_goals FROM periods WHERE game_id = ? AND team_id = ?) AS t2 ON t1.game_id = t2.game_id";
    
    arguements = @[game.gameID, game.homeID, game.gameID, game.awayID];
    
    FMResultSet *periods = [db executeQuery:query withArgumentsInArray:arguements];
    
    if ([periods next]) {
        
        game.homeScore = (short)[periods intForColumn:@"home_goals"];
        game.awayScore = (short)[periods intForColumn:@"away_goals"];
        game.homeShots = (short)[periods intForColumn:@"home_shots"];
        game.awayShots = (short)[periods intForColumn:@"away_shots"];
    }
    
    [periods close];
}

+(NSArray *)getPeriodsForGameID:(NSString *)gameID {
    
    __block NSArray *array = [NSArray array];
    
    FMDatabaseQueue *databaseQueue = [[self class] getDatabaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        
        FMResultSet *periods = [db executeQuery:@"SELECT * FROM periods WHERE game_id = ? ORDER BY period ASC" withArgumentsInArray:@[gameID]];
        
        while ([periods next]) {
            
            PeriodObject *period = [[PeriodObject alloc] init];
            
            period.gameID = [periods stringForColumn:@"game_id"];
            period.teamID = [periods stringForColumn:@"team_id"];
            period.period = (short)[periods intForColumn:@"period"];
            period.shots = (short)[periods intForColumn:@"shots"];
            period.goals = (short)[periods intForColumn:@"goals"];
            
            [temp addObject:period];
        }
        
        [periods close];
        
        array = temp;
    }];
    
    return array;
}

+(NSArray *)getEventsForGameID:(NSString *)gameID {
    
    __block NSArray *array = [NSArray array];
    
    FMDatabaseQueue *databaseQueue = [[self class] getDatabaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        
        FMResultSet *events = [db executeQuery:@"SELECT * FROM events WHERE game_id = ? ORDER BY period ASC, time ASC" withArgumentsInArray:@[gameID]];
        
        while ([events next]) {
            
            EventObject *event = [[EventObject alloc] init];
            
            event.eventID = [events intForColumn:@"id"];
            event.gameID = [events stringForColumn:@"game_id"];
            event.teamID = [events stringForColumn:@"team_id"];
            event.period = (short)[events intForColumn:@"period"];
            event.time = [events stringForColumn:@"time"];
            event.type = [events stringForColumn:@"type"];
            event.details = [events stringForColumn:@"description"];
            event.videoLink = [events stringForColumn:@"video_link"];
            event.formalID = [events stringForColumn:@"formal_id"];
            event.strength = [events stringForColumn:@"strength"];
            
            [temp addObject:event];
        }
        
        [events close];
        
        array = temp;
    }];
    
    return array;
}

+(short)getNumberOfPeriodsForGameID:(NSString *)gameID {
    
    __block short periodNumber;
    
    FMDatabaseQueue *databaseQueue = [[self class] getDatabaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *periods = [db executeQuery:@"SELECT MAX(period) FROM periods WHERE game_id = ?" withArgumentsInArray:@[gameID]];
        
        if ([periods next]) {
            
            periodNumber = (short)[periods intForColumnIndex:0];
        }
        
        [periods close];
    }];
    
    return periodNumber;
}

+(NSArray *)getGamesForDate:(NSDate *)date {
    
    __block NSArray *array = [NSArray array];
    
    FMDatabaseQueue *databaseQueue = [[self class] getDatabaseQueue];
    
    [databaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString *convertedDate = [DateTimeHandler getStringForDate:date];
        
        FMResultSet *games = [db executeQuery:@"SELECT * FROM games WHERE date = ? ORDER BY time ASC, date ASC, game_id ASC" withArgumentsInArray:@[convertedDate]];
        
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        
        while ([games next]) {
            
            GameObject *game = [[GameObject alloc] init];
            
            game.gameID = [games stringForColumn:@"game_id"];
            game.awayID = [games stringForColumn:@"away_id"];
            game.homeID = [games stringForColumn:@"home_id"];
            game.date = [games stringForColumn:@"date"];
            game.time = [games stringForColumn:@"time"];
            game.tv = [games stringForColumn:@"tv"];
            game.periodTime = [games stringForColumn:@"period_time"];
            game.period = (short)[games intForColumn:@"period"];
            game.homeStatus = [games stringForColumn:@"home_status"];
            game.awayStatus = [games stringForColumn:@"away_status"];
            game.seasonID = [games stringForColumn:@"season_id"];
            game.started = [games boolForColumn:@"started"];
            game.finished = [games boolForColumn:@"finished"];
            game.homeHighlight = [games stringForColumn:@"home_highlight"];
            game.awayHighlight = [games stringForColumn:@"away_highlight"];
            game.homeCondense = [games stringForColumn:@"home_condense"];
            game.awayCondense = [games stringForColumn:@"away_condense"];
            
            [temp addObject:game];
        }
        
        [games close];
        
        for (GameObject *object in temp) {
            
            [[self class] getScoreAndShotsForGame:object inDB:db];
        }
        
        array = temp;
    }];
    
    return array;
}

@end
