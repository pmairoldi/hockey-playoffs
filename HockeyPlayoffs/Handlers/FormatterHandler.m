//
//  FormatterHandler.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-08.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "FormatterHandler.h"

@interface FormatterHandler ()

@property NSDateFormatter *fullDateFormatter;
@property NSDateFormatter *fullDateTimeFormatter;
@property NSDateFormatter *longDateFormatter;
@property NSDateFormatter *timeFormatter;

@end

@implementation FormatterHandler


-(instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        NSLocale *en_US = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

        _fullDateFormatter = [[NSDateFormatter alloc] init];
        [_fullDateFormatter setLocale:en_US];
        [_fullDateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        _fullDateTimeFormatter = [[NSDateFormatter alloc] init];
        [_fullDateTimeFormatter setLocale:en_US];
        [_fullDateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        _longDateFormatter = [[NSDateFormatter alloc] init];
        [_longDateFormatter setDateFormat:@"MMM d, yyyy"];
        
        _timeFormatter = [[NSDateFormatter alloc] init];
        [_timeFormatter setDateFormat:@"h:mm a"];
    }
    
    return self;
}

+(instancetype)sharedHandler {
    
    static FormatterHandler *sharedHandler = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedHandler = [[self alloc] init];
    });
    
    return sharedHandler;
}

+(NSDateFormatter *)fullDateFormatter {
    
    return [[self sharedHandler] fullDateFormatter];
}

+(NSDateFormatter *)fullDateTimeFormatter {
    
    return [[self sharedHandler] fullDateTimeFormatter];
}

+(NSDateFormatter *)longDateFormatter {
    
    return [[self sharedHandler] longDateFormatter];
}

+(NSDateFormatter *)timeFormatter {
    
    return [[self sharedHandler] timeFormatter];
}

@end
