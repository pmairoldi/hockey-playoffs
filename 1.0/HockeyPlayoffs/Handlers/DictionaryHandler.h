//
//  DictionaryHandler.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryHandler : NSObject

+(NSString *)stringInDictionary:(NSDictionary *)dictionary withKey:(NSString *)key;
+(NSNumber *)numberInDictionary:(NSDictionary *)dictionary withKey:(NSString *)key;
+(NSDictionary *)dictionaryInDictionary:(NSDictionary *)dictionary withKey:(NSString *)key;
+(NSDictionary *)JSONDictionaryAtFile:(NSString *)file;

@end
