//
//  TeamHandlerTests.m
//  HockeyPlayoffs
//
//  Created by Pierre-Marc Airoldi on 2015-06-23.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TeamHandler.h"
#import "Colors.h"

@interface TeamHandlerTests : XCTestCase

@end

@implementation TeamHandlerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// test for
// +(NSString *)getTeamCity:(NSString *)teamABR
- (void)testGetTeamCityForNilAbbreviation {
    
    NSString *actualResult = [TeamHandler getTeamCity:nil];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

- (void)testGetTeamCityForEmptyAbbreviation {
    
    NSString *actualResult = [TeamHandler getTeamCity:@""];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

- (void)testGetTeamCityForNonDefinedAbbreviation {
    
    NSString *actualResult = [TeamHandler getTeamCity:@"TTYL"];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

- (void)testGetTeamCityForCorrectAbbreviation {
    
    NSString *actualResult = [TeamHandler getTeamCity:@"ana"];
    NSString *expectedResult = @"anaheim";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

// test for
// +(NSString *)getTeamName:(NSString *)teamABR
- (void)testGetTeamNameForNilAbbreviation {
    
    NSString *actualResult = [TeamHandler getTeamName:nil];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

- (void)testGetTeamNameForEmptyAbbreviation {
    
    NSString *actualResult = [TeamHandler getTeamName:@""];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

- (void)testGetTeamNameForNonDefinedAbbreviation {
    
    NSString *actualResult = [TeamHandler getTeamName:@"ttyl"];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

- (void)testGetTeamNameForCorrectAbbreviation {
    
    NSString *actualResult = [TeamHandler getTeamName:@"ana"];
    NSString *expectedResult = @"ducks";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

// test for
// +(NSString *)getTeamABR:(NSString *)teamName
- (void)testGetTeamAbbreviationForNilName {
    
    NSString *actualResult = [TeamHandler getTeamABR:nil];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

- (void)testGetTeamAbbreviationForEmptyName {
    
    NSString *actualResult = [TeamHandler getTeamABR:@""];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

- (void)testGetTeamAbbreviationForNonDefinedName {
    
    NSString *actualResult = [TeamHandler getTeamABR:@"dinosaurs"];
    NSString *expectedResult = @"";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

- (void)testGetTeamAbbreviationForCorrectName {
    
    NSString *actualResult = [TeamHandler getTeamABR:@"ducks"];
    NSString *expectedResult = @"ana";
    
    XCTAssert([actualResult isEqualToString:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

// tests for
// +(UIColor *)getTeamColor:(NSString *)teamABR
- (void)testGetTeamColorForNilName {
    
    UIColor *actualResult = [TeamHandler getTeamColor:nil];
    UIColor *expectedResult = [Colors lightGrayColor];
    
    XCTAssert([actualResult isEqual:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

- (void)testGetTeamColorForEmptyName {
    
    UIColor *actualResult = [TeamHandler getTeamColor:@""];
    UIColor *expectedResult = [Colors lightGrayColor];
    
    XCTAssert([actualResult isEqual:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

- (void)testGetTeamColorForNonDefinedName {
    
    UIColor *actualResult = [TeamHandler getTeamColor:@"ttyl"];
    UIColor *expectedResult = [Colors lightGrayColor];
    
    XCTAssert([actualResult isEqual:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

- (void)testGetTeamColorForCorrectName {
    
    UIColor *actualResult = [TeamHandler getTeamColor:@"ana"];
    UIColor *expectedResult = [UIColor colorWithRed:201.0/255.0 green:63.0/255.0 blue:16.0/255.0 alpha:1.0];
    
    XCTAssert([actualResult isEqual:expectedResult], "actual result: %@, expected results: %@", actualResult, expectedResult);
}

@end
