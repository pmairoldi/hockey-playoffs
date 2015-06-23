//
//  DateTimeHandler.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-07.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "DateTimeHandler.h"
#import "FormatterHandler.h"
#import "StringHandler.h"

@implementation DateTimeHandler

#pragma Public Methods

+(NSString *)getDateForDate:(NSString *)date andTime:(NSString *)time {
    
    if (![StringHandler compareString:date withRegex:@"\\d{4}-\\d{2}-\\d{2}"]) {
        return @"";
    }
    
    NSDate *formattedDate = [[self class] convertToTimeZoneForDate:date andTime:time];
    
    NSDateFormatter *formatter = [FormatterHandler longDateFormatter];
    
    return [formatter stringFromDate:formattedDate];
}

+(NSString *)getTimeForDate:(NSString *)date andTime:(NSString *)time {
    
    if (![StringHandler compareString:time withRegex:@"\\d{2}:\\d{2}:\\d{2}"]) {
        return NSLocalizedString(@"time.tbd", nil);
    }
    
    NSDate *formattedDate = [[self class] convertToTimeZoneForDate:date andTime:time];
    
    NSDateFormatter *formatter = [FormatterHandler timeFormatter];
    
    return [formatter stringFromDate:formattedDate];
}

+(NSString *)getStringForDate:(NSDate *)date {
    
    if (date == nil) {
        return @"";
    }
    
    NSDateFormatter *formatter = [FormatterHandler fullDateFormatter];
    
    NSDate *convertedData = [[self class] convertFromTimeZoneForDate:date];
    
    return [formatter stringFromDate:convertedData];
}

#pragma Private Methods

+(NSDate *)convertToTimeZoneForDate:(NSString *)date andTime:(NSString *)time {

    NSDateFormatter *formatter = [FormatterHandler fullDateTimeFormatter];

    if (date.length == 0) {
        date = @"1970-01-01";
    }
    
    if (time.length == 0) {
        time = @"00:00:00";
    }
    
    NSDate * sourceDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", date, time]];
    
	NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"EST"];
	NSTimeZone *destinationTimeZone = [NSTimeZone defaultTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    return destinationDate;
}

+(NSDate *)convertFromTimeZoneForDate:(NSDate *)date {
    
	NSTimeZone *sourceTimeZone = [NSTimeZone defaultTimeZone];
	NSTimeZone *destinationTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"EST"];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    
    return destinationDate;
}

@end
