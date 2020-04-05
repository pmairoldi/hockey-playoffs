//
//  PeriodObject.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;

@class GameObject;

@interface PeriodObject : NSObject

@property NSString *gameID;
@property NSString *teamID;
@property short period;
@property short shots;
@property short goals;

+(instancetype)objectForGameID:(NSString *)gameID team:(NSString *)team period:(short)period;
+(instancetype)objectFromDictionary:(NSDictionary *)dictionary;

-(NSArray *)arguments;

@end
