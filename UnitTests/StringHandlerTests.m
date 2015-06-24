//
//  StringHandlerTests.m
//  HockeyPlayoffs
//
//  Created by Pierre-Marc Airoldi on 2015-06-23.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "StringHandler.h"

@interface StringHandlerTests : XCTestCase

@end

@implementation StringHandlerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNilStringAndNilRegex {
    
    BOOL actualResult = [StringHandler compareString:nil withRegex:nil];
    BOOL expectedResult = false;
    
    XCTAssertEqual(actualResult, expectedResult, "actual result: %d, expected results: %d", actualResult, expectedResult);
}

- (void)testEmptyStringAndEmptyRegex {
    
    BOOL actualResult = [StringHandler compareString:@"" withRegex:@""];
    BOOL expectedResult = false;
    
    XCTAssertEqual(actualResult, expectedResult, "actual result: %d, expected results: %d", actualResult, expectedResult);
}

- (void)testEmptyStringAndNilRegex {
    
    BOOL actualResult = [StringHandler compareString:@"" withRegex:nil];
    BOOL expectedResult = false;
    
    XCTAssertEqual(actualResult, expectedResult, "actual result: %d, expected results: %d", actualResult, expectedResult);
}

- (void)testNilStringAndEmptyRegex {
    
    BOOL actualResult = [StringHandler compareString:nil withRegex:@""];
    BOOL expectedResult = false;
    
    XCTAssertEqual(actualResult, expectedResult, "actual result: %d, expected results: %d", actualResult, expectedResult);
}

- (void)testCorrectStringAndWrongRegex {
    
    BOOL actualResult = [StringHandler compareString:@"12" withRegex:@"\\d{4}"];
    BOOL expectedResult = false;
    
    XCTAssertEqual(actualResult, expectedResult, "actual result: %d, expected results: %d", actualResult, expectedResult);
}

- (void)testCorrectStringAndCorrectRegex {
    
    BOOL actualResult = [StringHandler compareString:@"1234" withRegex:@"\\d{4}"];
    BOOL expectedResult = true;
    
    XCTAssertEqual(actualResult, expectedResult, "actual result: %d, expected results: %d", actualResult, expectedResult);
}

@end
