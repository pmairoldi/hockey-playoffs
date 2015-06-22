//
//  PeriodObject.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "PeriodObject.h"
#import "DictionaryHandler.h"
#import "APIIdentifiers.h"
#import "GameObject.h"
#import "NSObject+PMDescription.h"

@implementation PeriodObject

-(id)init {
    
    self = [super init];
    
    if (self) {
        
        _gameID = @"";
        _teamID = @"";
    }
    
    return self;
}

+(instancetype)objectForGameID:(NSString *)gameID team:(NSString *)team period:(short)period {
    
    PeriodObject *object = [[PeriodObject alloc] init];
    
    object.gameID = gameID;
    object.teamID = team;
    object.period = period;
    object.shots = 0;
    object.goals = 0;
    
    return object;
}

+(instancetype)objectFromDictionary:(NSDictionary *)dictionary {
    
    PeriodObject *object = [[PeriodObject alloc] init];
    
    object.gameID = [DictionaryHandler stringInDictionary:dictionary withKey:kGameIDJSONKey];
    object.teamID = [DictionaryHandler stringInDictionary:dictionary withKey:kTeamIDJSONKey];
    object.period = [[DictionaryHandler numberInDictionary:dictionary withKey:kPeriodJSONKey] shortValue];
    object.shots = [[DictionaryHandler numberInDictionary:dictionary withKey:kShotsJSONKey] shortValue];
    object.goals = [[DictionaryHandler numberInDictionary:dictionary withKey:kGoalsJSONKey] shortValue];

    return object;
}

-(NSArray *)arguments {
    
    NSArray *array = [NSArray arrayWithObjects:_gameID,_teamID,[NSNumber numberWithShort:_period],[NSNumber numberWithShort:_shots],[NSNumber numberWithShort:_goals],nil];
    
    return array;
}

-(NSString *)description {
    return [self pm_description];
}

@end
