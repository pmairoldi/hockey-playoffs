//
//  GameObject.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "GameObject.h"
#import "DictionaryHandler.h"
#import "APIIdentifiers.h"
#import "DateTimeHandler.h"
#import "NSObject+PMDescription.h"

@implementation GameObject

-(id)init {
    
    self = [super init];
    
    if (self) {
        
        _gameID = @"";
        _awayID = @"";
        _homeID = @"";
        _date = @"";
        _time = @"";
        _tv = @"";
        _periodTime = @"";
        _homeStatus = @"";
        _awayStatus = @"";
        _seasonID = @"";
        _homeHighlight = @"";
        _awayHighlight = @"";
        _homeCondense = @"";
        _awayCondense = @"";
        _active = 1;
    }
    
    return self;
}

+(instancetype)objectFromDictionary:(NSDictionary *)dictionary {
    
    GameObject *object = [[GameObject alloc] init];
    
    object.gameID = [DictionaryHandler stringInDictionary:dictionary withKey:kGameIDJSONKey];
    object.awayID = [DictionaryHandler stringInDictionary:dictionary withKey:kAwayIDJSONKey];
    object.homeID = [DictionaryHandler stringInDictionary:dictionary withKey:kHomeIDJSONKey];
    object.date = [DictionaryHandler stringInDictionary:dictionary withKey:kDataJSONKey];
    object.time = [DictionaryHandler stringInDictionary:dictionary withKey:kTimeJSONKey];
    object.tv = [DictionaryHandler stringInDictionary:dictionary withKey:kTVJSONKey];
    object.period = [[DictionaryHandler numberInDictionary:dictionary withKey:kPeriodJSONKey] shortValue];
    object.periodTime = [DictionaryHandler stringInDictionary:dictionary withKey:kPeriodTimeJSONKey];
    object.homeStatus = [DictionaryHandler stringInDictionary:dictionary withKey:kHomeStatusJSONKey];
    object.awayStatus = [DictionaryHandler stringInDictionary:dictionary withKey:kAwayStatusJSONKey];
    object.seasonID = [DictionaryHandler stringInDictionary:dictionary withKey:kSeasonIDJSONKey];
    object.started = [[DictionaryHandler numberInDictionary:dictionary withKey:kStartedJSONKey] boolValue];
    object.finished = [[DictionaryHandler numberInDictionary:dictionary withKey:kFinishedJSONKey] boolValue];
    object.homeHighlight = [DictionaryHandler stringInDictionary:dictionary withKey:kHomeHighlightJSONKey];
    object.awayHighlight = [DictionaryHandler stringInDictionary:dictionary withKey:kAwayHighlightJSONKey];
    object.homeCondense = [DictionaryHandler stringInDictionary:dictionary withKey:kHomeCondenseJSONKey];
    object.awayCondense = [DictionaryHandler stringInDictionary:dictionary withKey:kAwayCondenseJSONKey];
    object.active = [[DictionaryHandler numberInDictionary:dictionary withKey:kActiveJSONkey] boolValue];
    
    return object;
}

-(NSArray *)arguments {
    
    NSArray *array = [NSArray arrayWithObjects:_gameID,_awayID,_homeID,_date,_time,_tv,[NSNumber numberWithShort:_period],_periodTime,_homeStatus,_awayStatus,_seasonID,[NSNumber numberWithBool:_started],[NSNumber numberWithBool:_finished],_homeHighlight,_awayHighlight,_homeCondense,_awayCondense,nil];
    
    return array;
}

-(short)getScoreForTeam:(NSString *)team {
    
    if ([team isEqualToString:_homeID]) {
        return _homeScore;
    }
    
    else if ([team isEqualToString:_awayID]) {
        return _awayScore;
    }
    
    else {
        return 0;
    }
}

-(BOOL)hasWonGame:(NSString *)team {
    
    if ([team isEqualToString:_homeID]) {
        
        return _homeScore > _awayScore;
    }
    
    else {
        return _awayScore > _homeScore;
    }
}

-(BOOL)hasVideo {
    
    if (_homeHighlight.length != 0 || _awayHighlight.length != 0) {
        
        return YES;
    }
    
    else {
        
        return NO;
    }
}

-(NSArray *)videoLinks {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (_homeHighlight.length != 0) {
        
        [array addObject:[NSURL URLWithString:_homeHighlight]];
    }

    if (_awayHighlight.length != 0) {
        
        [array addObject:[NSURL URLWithString:_awayHighlight]];
    }

    return array;
}

-(NSString *)getGameText {
    
    NSString *gameID = [_gameID stringByReplacingCharactersInRange:NSMakeRange(0, 9) withString:@""];
  
    return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"game", nil) , gameID];
}

-(NSString *)getGameStatus {
    
    if (_period == 0){
        //not started show game time
        
        NSString *date = [DateTimeHandler getDateForDate:_date andTime:_time];
        NSString *time = [DateTimeHandler getTimeForDate:_date andTime:_time];
        
        return [NSString stringWithFormat:@"%@\n%@", date, time];
    }
    
    else {
        //started show period data
        NSString *periodTime;
        
        if (_periodTime.length != 0) {
            periodTime = NSLocalizedString(_periodTime, nil);
        }
        
        else {
            periodTime = @"20:00";
        }
        
        NSString *periodTitle;
        
        switch (_period) {
                
            case 0:
                periodTitle = NSLocalizedString(@"period.first.short", nil);
                break;
                
            case 1:
                periodTitle = NSLocalizedString(@"period.first.short", nil);
                break;
                
            case 2:
                periodTitle = NSLocalizedString(@"period.second.short", nil);
                break;
                
            case 3:
                periodTitle = NSLocalizedString(@"period.third.short", nil);
                break;
                
            case 4:
                periodTitle = NSLocalizedString(@"period.ot.short", nil);
                break;
                
            case 5:
                periodTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"period.second.short", nil), NSLocalizedString(@"period.ot.short", nil)];
                break;
                
            case 6:
                periodTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"period.third.short", nil), NSLocalizedString(@"period.ot.short", nil)];
                break;
                
            default:
                periodTitle = [NSString stringWithFormat:@"%d%@ %@", _period-3, NSLocalizedString(@"period.number.ending", nil), NSLocalizedString(@"period.ot.short", nil)];
                break;
        }
        
        return [NSString stringWithFormat:@"%@\n%@", periodTime, periodTitle];
    }
}

-(NSArray *)getEnabledVideos {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];

    if (_homeHighlight.length != 0) {
        
        [array insertObject:@(1) atIndex:0];
    }
    
    else {
        [array insertObject:@(0) atIndex:0];
    }
    
    if (_awayHighlight.length != 0) {
        
        [array insertObject:@(1) atIndex:1];
    }
    
    else {
        [array insertObject:@(0) atIndex:1];
    }
    
    return array;
}

-(NSString *)getRelativeGameID {
    return [_gameID stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:@""];
}

-(NSString *)description {
    return [self pm_description];
}

@end
