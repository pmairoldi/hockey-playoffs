//
//  TeamObject.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;

@interface TeamObject : NSObject

@property NSString *seasonID;
@property NSString *homeID;
@property NSString *awayID;
@property NSString *conference;
@property short round;
@property short seed;

+(instancetype)objectFromDictionary:(NSDictionary *)dictionary;

-(NSArray *)arguments;

@end
