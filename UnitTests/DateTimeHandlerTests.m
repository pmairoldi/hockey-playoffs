//
//  UnitTests.m
//  UnitTests
//
//  Created by Pierre-Marc Airoldi on 2015-06-22.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DateTimeHandler.h"

@interface UnitTests : XCTestCase

@property NSTimeZone *cachedTimeZone;


@end

@implementation UnitTests

- (void)setUp {
    [super setUp];
    
    _cachedTimeZone = [NSTimeZone defaultTimeZone];
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
}

- (void)tearDown {
    
    [NSTimeZone setDefaultTimeZone:_cachedTimeZone];
    
    [super tearDown];
}

// tests for
// +(NSString *)getDateForDate:(NSString *)date andTime:(NSString *)time
-(void)testDateFromEmptyDateAndEmptyTime {
    
    NSString *actualResult = [DateTimeHandler getDateForDate:@"" andTime:@""];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testDateFromNilDateAndNilTime {
    
    NSString *actualResult = [DateTimeHandler getDateForDate:nil andTime:nil];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testDateFromEmptyDateAndNilTime {
    
    NSString *actualResult = [DateTimeHandler getDateForDate:@"" andTime:nil];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testDateFromNilDateAndEmptyTime {
    
    NSString *actualResult = [DateTimeHandler getDateForDate:@"" andTime:nil];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testDateFromIncorectlyFormattedDateAndNilTime {
    
    NSString *actualResult = [DateTimeHandler getDateForDate:@"22/6/2015" andTime:nil];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testDateFromIncorectlyFormattedDateAndEmptyTime {
    
    NSString *actualResult = [DateTimeHandler getDateForDate:@"22/6/2015" andTime:@""];
    NSString *expectedResult = @"";

    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testDateFromWellFormattedDateAndNilTime {
    
    NSString *actualResult = [DateTimeHandler getDateForDate:@"2015-06-22" andTime:nil];
    NSString *expectedResult = @"Jun 22, 2015";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testDateFromWellFormattedDateAndEmptyTime {
    
    NSString *actualResult = [DateTimeHandler getDateForDate:@"2015-06-22" andTime:@""];
    NSString *expectedResult = @"Jun 22, 2015";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testDateFromWellFormattedDateAndTime {
    
    NSString *actualResult = [DateTimeHandler getDateForDate:@"2015-06-22" andTime:@"10:53:00"];
    NSString *expectedResult = @"Jun 22, 2015";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

// tests for
// +(NSString *)getTimeForDate:(NSString *)date andTime:(NSString *)time
-(void)testTimeFromEmptyDateAndEmptyTime {
    
    NSString *actualResult = [DateTimeHandler getTimeForDate:@"" andTime:@""];
    NSString *expectedResult = NSLocalizedString(@"time.tbd", nil);
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testTimeFromNilDateAndNilTime {
    
    NSString *actualResult = [DateTimeHandler getTimeForDate:nil andTime:nil];
    NSString *expectedResult = NSLocalizedString(@"time.tbd", nil);
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testTimeFromEmptyDateAndNilTime {
    
    NSString *actualResult = [DateTimeHandler getTimeForDate:@"" andTime:nil];
    NSString *expectedResult = NSLocalizedString(@"time.tbd", nil);
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testTimeFromNilDateAndEmptyTime {
    
    NSString *actualResult = [DateTimeHandler getTimeForDate:@"" andTime:nil];
    NSString *expectedResult = NSLocalizedString(@"time.tbd", nil);
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testTimeFromIncorectlyFormattedTimeAndNilDate {
    
    NSString *actualResult = [DateTimeHandler getTimeForDate:nil andTime:@"10:00 PM"];
    NSString *expectedResult = NSLocalizedString(@"time.tbd", nil);
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testTimeFromIncorectlyFormattedTimeAndEmptyDate {
    
    NSString *actualResult = [DateTimeHandler getTimeForDate:@"" andTime:@"10:00 PM"];
    NSString *expectedResult = NSLocalizedString(@"time.tbd", nil);
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testTimeFromWellFormattedTimeAndNilDate {
    
    NSString *actualResult = [DateTimeHandler getTimeForDate:nil andTime:@"10:53:00"];
    NSString *expectedResult = @"10:53 AM";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testTimeFromWellFormattedTimeAndEmptyDate {
    
    NSString *actualResult = [DateTimeHandler getTimeForDate:@"" andTime:@"10:53:00"];
    NSString *expectedResult = @"10:53 AM";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testTimeFromWellFormattedDateAndTime {
    
    NSString *actualResult = [DateTimeHandler getTimeForDate:@"2015-06-22" andTime:@"10:53:00"];
    NSString *expectedResult = @"10:53 AM";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

// tests for
// +(NSString *)getStringForDate:(NSDate *)date;
-(void)testStringDateFromNilDate {
    
    NSString *actualResult = [DateTimeHandler getStringForDate:nil];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

-(void)testStringDateFromDate {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];

    NSString *actualResult = [DateTimeHandler getStringForDate:date];
    NSString *expectedResult = @"1969-12-31"; //since the time is converted to EST from UTC is is the day before epoch
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

@end
