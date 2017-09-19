//
//  EventObject.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-06.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "EventObject.h"
#import "DictionaryHandler.h"
#import "APIIdentifiers.h"
#import "NSObject+PMDescription.h"

@implementation EventObject

-(id)init {
    
    self = [super init];
    
    if (self) {
        
        _gameID = @"";
        _teamID = @"";
        _time = @"";
        _type = @"";
        _details = @"";
        _videoLink = @"";
        _formalID = @"";
        _strength = @"";
    }
    
    return self;
}

+(instancetype)objectFromDictionary:(NSDictionary *)dictionary {
    
    EventObject *object = [[EventObject alloc] init];
    
    object.eventID = [[DictionaryHandler numberInDictionary:dictionary withKey:kEventIDJSONKey] intValue];
    object.gameID = [DictionaryHandler stringInDictionary:dictionary withKey:kGameIDJSONKey];
    object.teamID = [DictionaryHandler stringInDictionary:dictionary withKey:kTeamIDJSONKey];
    object.period = [[DictionaryHandler numberInDictionary:dictionary withKey:kPeriodJSONKey] shortValue];
    object.time = [DictionaryHandler stringInDictionary:dictionary withKey:kTimeJSONKey];
    object.type = [DictionaryHandler stringInDictionary:dictionary withKey:kTypeJSONKEY];
    object.details = [DictionaryHandler stringInDictionary:dictionary withKey:kDescriptionJSONKey];
    object.videoLink = [DictionaryHandler stringInDictionary:dictionary withKey:kVideoLinkJSONKey];
    object.formalID = [DictionaryHandler stringInDictionary:dictionary withKey:kEventFormalIDJSONKey];
    object.strength = [DictionaryHandler stringInDictionary:dictionary withKey:kStrengthJSONKey];
 
    return object;
}

-(NSArray *)arguments {
    
    return @[@(_eventID), _gameID, _teamID, @(_period), _time, _type, _details, _videoLink, _formalID, _strength];
}

-(NSString *)description {
    return [self pm_description];
}

@end
