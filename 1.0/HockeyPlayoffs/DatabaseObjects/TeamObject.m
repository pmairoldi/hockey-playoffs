//
//  TeamObject.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "TeamObject.h"
#import "DictionaryHandler.h"
#import "APIIdentifiers.h"
#import "NSObject+PMDescription.h"

@implementation TeamObject

-(id)init {
    
    self = [super init];
    
    if (self) {
        
        _seasonID = @"";
        _homeID = @"";
        _awayID = @"";
        _conference = @"";
    }
    
    return self;
}

+(instancetype)objectFromDictionary:(NSDictionary *)dictionary {
    
    TeamObject *object = [[TeamObject alloc] init];
    
    object.seasonID = [DictionaryHandler stringInDictionary:dictionary withKey:kSeasonIDJSONKey];
    object.homeID = [DictionaryHandler stringInDictionary:dictionary withKey:kHomeIDJSONKey];
    object.awayID = [DictionaryHandler stringInDictionary:dictionary withKey:kAwayIDJSONKey];
    object.conference = [DictionaryHandler stringInDictionary:dictionary withKey:kConferenceJSONKey];
    object.round = [[DictionaryHandler numberInDictionary:dictionary withKey:kRoundJSONKey] shortValue];
    object.seed = [[DictionaryHandler numberInDictionary:dictionary withKey:kSeedJSONKey] shortValue];

    return object;
}

-(NSArray *)arguments {
    
    NSArray *array = [NSArray arrayWithObjects:_seasonID,_homeID,_awayID,_conference,[NSNumber numberWithShort:_round],[NSNumber numberWithShort:_seed],nil];
    
    return array;
}

-(NSString *)description {
    return [self pm_description];
}

@end
