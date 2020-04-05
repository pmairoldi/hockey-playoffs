//
//  EventObject.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-06.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;

@interface EventObject : NSObject

@property int eventID;
@property NSString *gameID;
@property NSString *teamID;
@property short period;
@property NSString *time;
@property NSString *type;
@property NSString *details;
@property NSString *videoLink;
@property NSString *formalID;
@property NSString *strength;

+(instancetype)objectFromDictionary:(NSDictionary *)dictionary;

-(NSArray *)arguments;

@end
