//
//  GameModel.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-09.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import UIKit;
#import "GameModel.h"
#import "EventObject.h"
#import "GameObject.h"
#import "DatabaseHandler.h"
#import "PeriodObject.h"
#import "Queues.h"

@interface GameModel ()

@property NSArray *periodObjects;
@property NSArray *eventObjects;
@property short periods;
@property NSUInteger game;

@end

@implementation GameModel

+(instancetype)initWithGame:(GameObject *)game {
    
    GameModel *gameModel = [[GameModel alloc] init];
    
    gameModel.gameObject = game;
    
    gameModel.expandedIndex = -1;
    
    return gameModel;
}

-(void)setExpandedIndex:(int)index {
    
    if (_expandedIndex == index) {
        _expandedIndex = -1;
    }
    
    else {
        _expandedIndex = index;
    }
}

-(NSInteger)numberOfSections {
    
    return 1 + MAX(_periods, 3);
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if (_isRefreshing) {
            return 1;
        }
        
        else {
            return 0;
        }
    }
    
    else {
        
        NSString *type;
        
        switch (_sectionIndex) {
            case 0:
                type = @"goal";
                break;
            case 1:
                type = @"penalty";
                break;
            default:
                type = @"";
                break;
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type MATCHES %@ AND period = %d", type, section];
        
        if (predicate) {
            NSArray *array = [_eventObjects filteredArrayUsingPredicate:predicate];
            
            if (array.count > 0) {
                return [array count];
            }
            
            else {
                return 1;
            }
        }
        
        else {
            return 1;
        }
    }
}

-(NSUInteger)getScoreForTeam:(NSString *)team {
    
    if ([team isEqualToString:[self homeTeam]]) {
        
        return _gameObject.homeScore;
    }
    
    else if ([team isEqualToString:[self awayTeam]]){
        
        return _gameObject.awayScore;
    }
    
    else {
        return 0;
    }
}

-(PeriodObject *)getPeriodObjectForTeam:(NSString *)team inPeriod:(NSUInteger)period {
    
    if (period == 4) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"period >= %d AND teamID MATCHES %@", period, team];
        
        if (predicate) {
            PeriodObject *periodObject = [[_periodObjects filteredArrayUsingPredicate:predicate] lastObject];
            return periodObject;
        }
        
        else {
            return nil;
        }
    }
    
    else {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"period = %d AND teamID MATCHES %@", period, team];
        
        if (predicate) {
            PeriodObject *periodObject = [[_periodObjects filteredArrayUsingPredicate:predicate] firstObject];
            return periodObject;
        }
        
        else {
            return nil;
        }
    }
}

-(BOOL)hasOTPeriod {
    
    if (_gameObject.period >= 4) {
        return YES;
    }
    
    else {
        return NO;
    }
}

-(short)otPeriod {
    
    if (_gameObject.period >= 4) {
        
        return _gameObject.period - 3;
    }
    
    else {
        return 0;
    }
}

-(NSUInteger)getScoreForTeam:(NSString *)team inPeriod:(NSUInteger)period {
    
    PeriodObject *periodObject = [self getPeriodObjectForTeam:team inPeriod:period];
    
    if (periodObject != nil) {
        
        return [periodObject goals];
    }
    
    else {
        return 0;
    }
}

-(NSUInteger)getShotsForTeam:(NSString *)team {
    
    if ([team isEqualToString:[self homeTeam]]) {
        
        return _gameObject.homeShots;
    }
    
    else if ([team isEqualToString:[self awayTeam]]){
        
        return _gameObject.awayShots;
    }
    
    else {
        return 0;
    }
}

-(NSUInteger)getShotsForTeam:(NSString *)team inPeriod:(NSUInteger)period {
    
    PeriodObject *periodObject = [self getPeriodObjectForTeam:team inPeriod:period];
    
    if (periodObject != nil) {
        
        return [periodObject shots];
    }
    
    else {
        return 0;
    }
}


-(BOOL)isTeamHome:(NSString *)team {
    
    if ([team isEqualToString:[self homeTeam]]) {
        return YES;
    }
    
    else {
        return NO;
    }
}

-(BOOL)hasWonGame:(NSString *)team {
    
    if ([self isTeamHome:team]) {
        
        return [self getScoreForTeam:[self homeTeam]] > [self getScoreForTeam:[self awayTeam]];
    }
    
    else {
        return [self getScoreForTeam:[self awayTeam]] > [self getScoreForTeam:[self homeTeam]];
    }
}

-(BOOL)hasNoEventsAtIndex:(NSIndexPath *)indexPath {
    
    NSArray *events = [self getEventsArrayInSection:indexPath.section];
    
    if ([events count] > 0) {
        return NO;
    }
    
    else {
        return YES;
    }
}

-(NSString *)getNoDataText {
    
    NSString *type;
    
    switch (_sectionIndex) {
        case 0:
            type = @"game.nogoals";
            break;
        case 1:
            type = @"game.nopenalties";
            break;
        default:
            type = @"";
            break;
    }
    
    return NSLocalizedString(type, nil);
}


-(NSArray *)getEventsArrayInSection:(NSUInteger)section {
    
    NSString *type;
    
    switch (_sectionIndex) {
        case 0:
            type = @"goal";
            break;
        case 1:
            type = @"penalty";
            break;
        default:
            type = @"";
            break;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type MATCHES %@ AND period = %d", type, section];
    
    if (predicate) {
        NSArray *events = [_eventObjects filteredArrayUsingPredicate:predicate];
        
        if (events == nil) {
            return [NSArray array];
        }
        
        return events;
    }
    
    else {
        return @[];
    }
}

-(EventObject *)getEventAtIndex:(NSIndexPath *)indexPath {
    
    NSArray *events = [self getEventsArrayInSection:indexPath.section];
    
    if (indexPath.row >= [events count]) {
        
        return nil;
    }
    
    else {
        return [events objectAtIndex:indexPath.row];
    }
}

-(NSString *)getPeriodAtIndex:(NSInteger)section {
    
    NSString *periodTitle;
    
    switch (section) {
            
        case 0:
            periodTitle = @"";
            break;
            
        case 1:
            periodTitle = NSLocalizedString(@"period.first", nil);
            break;
            
        case 2:
            periodTitle = NSLocalizedString(@"period.second", nil);
            break;
            
        case 3:
            periodTitle = NSLocalizedString(@"period.third", nil);
            break;
            
        case 4:
            periodTitle = NSLocalizedString(@"period.ot", nil);
            break;
            
        case 5:
            periodTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"period.second", nil), NSLocalizedString(@"period.ot", nil)];
            break;
            
        case 6:
            periodTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"period.third", nil), NSLocalizedString(@"period.ot", nil)];
            break;
            
        default:
            periodTitle = [NSString stringWithFormat:@"%d%@ %@", (int)section-3, NSLocalizedString(@"period.number.ending", nil), NSLocalizedString(@"period.ot", nil)];
            break;
    }
    
    return periodTitle;
}

-(NSString *)getTitle {
    
    if (_gameObject.gameID.length == 10) {
        
        unichar gameID = [_gameObject.gameID characterAtIndex:9];
        
        _game = [[NSString stringWithFormat:@"%c", gameID] integerValue];
    }
    
    else {
        _game = NSNotFound;
    }
    
    if (_game == NSNotFound || _game == 0) {
        
        return NSLocalizedString(@"game.title", nil);
    }
    
    else {
        return [NSString stringWithFormat:@"%@ %ld", NSLocalizedString(@"game.title", nil), (unsigned long)_game];
    }
}

+(NSArray *)getSectionItems {
    
    return [NSArray arrayWithObjects:NSLocalizedString(@"game.section.goals", nil), NSLocalizedString(@"game.section.penalties", nil),/* NSLocalizedString(@"game.section.hits", nil), NSLocalizedString(@"game.section.saves", nil), NSLocalizedString(@"game.section.saves", nil),*/ nil];
}

-(BOOL)isVideoAvailable {
    
    return [_gameObject hasVideo];
}

-(NSURL *)getVideoLink {
    
    NSArray *videoLinks = [_gameObject videoLinks];
    
    if (videoLinks.count > 0) {
        
        NSString *videoLink = [videoLinks firstObject];
        
        return [NSURL URLWithString:videoLink];
    }
    
    else {
        return nil;
    }
}

-(NSString *)homeTeam {
    
    return _gameObject.homeID;
}

-(NSString *)awayTeam {
    
    return _gameObject.awayID;
}

-(void)refresh {
    
    _gameObject = [DatabaseHandler getGameForID:_gameObject.gameID];
    
    _periodObjects = [DatabaseHandler getPeriodsForGameID:_gameObject.gameID];
    
    _eventObjects = [DatabaseHandler getEventsForGameID:_gameObject.gameID];
    
    _periods = [DatabaseHandler getNumberOfPeriodsForGameID:_gameObject.gameID];
}

-(void)refresh:(void(^)(BOOL reload))completion {
    
    _isRefreshing = YES;
    
    if (completion == nil) {
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        dispatch_async(DB_FETCH_QUEUE, ^{
            
            [self refresh];
            
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        _isRefreshing = NO;
    }
    
    else {
        
        dispatch_async(DB_FETCH_QUEUE, ^{
            
            [self refresh];
            
            self.isRefreshing = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(YES);
            });
        });
    }
}

@end
