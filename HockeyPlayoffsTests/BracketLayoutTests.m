@import XCTest;
#import "BracketView.h"
#import "Rectangle.h"

@interface BracketLayoutTests : XCTestCase
@end

@implementation BracketLayoutTests

- (void)testCentralConnectorsStayOnTheCenterlineAfterResizing {
    BracketView *bracket = [[BracketView alloc] initWithFrame:CGRectZero];
    NSArray<NSValue *> *sizes = @[
        [NSValue valueWithCGSize:CGSizeMake(382, 644)],
        [NSValue valueWithCGSize:CGSizeMake(867, 635)],
        [NSValue valueWithCGSize:CGSizeMake(585, 917)],
        [NSValue valueWithCGSize:CGSizeMake(750, 338)],
        [NSValue valueWithCGSize:CGSizeMake(382, 644)]
    ];
    for (NSValue *size in sizes) {
        bracket.bounds = (CGRect){CGPointZero, size.CGSizeValue};
        for (NSInteger round = west_final; round <= east_final; round++) {
            // BracketSection draws its vertical stems from these endpoints.
            // Every single-matchup round belongs on the content centerline.
            NSArray<Rectangle *> *endpoints = [bracket getFramesForRound:(enum round)round];
            XCTAssertEqual(endpoints.count, 1);
            Rectangle *endpoint = endpoints.firstObject;
            XCTAssertEqualWithAccuracy(endpoint.x + endpoint.width / 2, CGRectGetMidX(bracket.bounds), 0.01,
                                       @"Off-center connector for round %ld at %@", (long)round, size);
        }
    }
}

@end
