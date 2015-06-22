//
//  DateTimeHandler.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-07.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeHandler : NSObject

+(NSString *)getDateForDate:(NSString *)date andTime:(NSString *)time;
+(NSString *)getTimeForDate:(NSString *)date andTime:(NSString *)time;
+(NSString *)getStringForDate:(NSDate *)date;

@end
