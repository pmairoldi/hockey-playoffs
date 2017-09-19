//
//  DictionaryHandler.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "DictionaryHandler.h"
#import "FormatterHandler.h"

@implementation DictionaryHandler

+(NSString *)stringInDictionary:(NSDictionary *)dictionary withKey:(NSString *)key {
    
    if ([dictionary objectForKey:key] != [NSNull null] && [dictionary objectForKey:key] != nil) {
        return [dictionary objectForKey:key];
    }
    else {
        return @"";
    }
}

+(NSNumber *)numberInDictionary:(NSDictionary *)dictionary withKey:(NSString *)key {
    
    if ([dictionary objectForKey:key] != [NSNull null] && [dictionary objectForKey:key] != nil) {
        
        NSNumber *number;
        
        id object = [dictionary objectForKey:key];
        
        if ([object isKindOfClass:[NSString class]]) {
            
            if (object != nil && object != [NSNull null]) {
                
                NSString *string = (NSString *)object;
                number = [NSNumber numberWithInt:[string intValue]];
            }
            
            else {
                number = [NSNumber numberWithInt:0];
            }
        }
        
        else if ([object isKindOfClass:[NSNumber class]]){
            
            number = object;
        }
        
        else {
            
            number = [NSNumber numberWithInt:0];
        }
        
        return number;
    }
    
    else {
        
        return [NSNumber numberWithInt:0];
    }
}

+(NSDictionary *)dictionaryInDictionary:(NSDictionary *)dictionary withKey:(NSString *)key {
    
    if ([dictionary objectForKey:key] != [NSNull null] && [dictionary objectForKey:key] != nil) {
        return [dictionary objectForKey:key];
    }
    else {
        return [NSDictionary dictionary];
    }
}

+(NSDictionary *)JSONDictionaryAtFile:(NSString *)file {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (error != nil) {
        return [NSDictionary dictionary];
    }
    
    return dictionary;
}

@end
