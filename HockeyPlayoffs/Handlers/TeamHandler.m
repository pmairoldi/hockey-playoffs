//
//  TeamHandler.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2013-09-29.
//  Copyright (c) 2013 Pierre-Marc Airoldi. All rights reserved.
//

#import "TeamHandler.h"
#import "Colours.h"
#import "DictionaryHandler.h"

@implementation TeamHandler

#pragma Public Methods

+(NSString *)getTeamCity:(NSString *)teamABR {
    
    NSDictionary *team = [[self class] getTeamForAbbreavation:teamABR];
    
    return [DictionaryHandler stringInDictionary:team withKey:@"city"];
}

+(NSString *)getTeamName:(NSString *)teamABR {
    
    NSDictionary *team = [[self class] getTeamForAbbreavation:teamABR];
    
    return [DictionaryHandler stringInDictionary:team withKey:@"name"];
}

+(NSString *)getTeamABR:(NSString *)teamName {
    
    if (teamName.length == 0) {
        return @"";
    }
    
    NSArray *teams = [[[self class] teamsDictionary] allValues];
    
    for (NSDictionary *team in teams) {
        
        NSString *nameInDictionary = [DictionaryHandler stringInDictionary:team withKey:@"name"];
        NSString *nameToFind = [teamName lowercaseString];
        
        if ([nameInDictionary isEqualToString:nameToFind]) {
            
            NSArray *keys = [[[self class] teamsDictionary] allKeysForObject:team];
            return [keys firstObject];
        }
    }
    
    return @"";
}

+(UIColor *)getTeamColor:(NSString *)teamABR {
    
    if (teamABR.length >= 3) {
        
        NSString *trimmedAbr = [teamABR substringToIndex:3];
        
        NSDictionary *team = [[self class] getTeamForAbbreavation:trimmedAbr];
        
        NSDictionary *colors = [DictionaryHandler dictionaryInDictionary:team withKey:@"color"];
        
        NSNumber *red = [DictionaryHandler numberInDictionary:colors withKey:@"red"];
        NSNumber *green = [DictionaryHandler numberInDictionary:colors withKey:@"green"];
        NSNumber *blue = [DictionaryHandler numberInDictionary:colors withKey:@"blue"];
        
        if ([red integerValue] == 0 && [green integerValue] == 0 && [blue integerValue] == 0) {
            return LIGHT_GRAY_COLOUR;
        }
        
        else {
            return [UIColor colorWithRed:[[self class] convertToPercentValue:red] green:[[self class] convertToPercentValue:green] blue:[[self class] convertToPercentValue:blue] alpha:1.0];
        }
    }
    
    else {
        return LIGHT_GRAY_COLOUR;
    }
}

#pragma Private Methods

+(CGFloat)convertToPercentValue:(NSNumber *)colorComponent {
    
    return [colorComponent floatValue]/255.0;
}

+(NSDictionary *)teamsDictionary {
    
    return [DictionaryHandler JSONDictionaryAtFile:@"teams"];
}

+(NSDictionary *)getTeamForAbbreavation:(NSString *)teamABR {
    
    teamABR = [teamABR lowercaseString];
    
    NSDictionary *teamDictionary = [[[self class] teamsDictionary] objectForKey:teamABR];
    
    if (teamDictionary == nil) {
        return [NSDictionary dictionary];
    }
    
    return teamDictionary;
}

@end
