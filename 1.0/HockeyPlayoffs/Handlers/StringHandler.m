//
//  StringHandler.m
//  HockeyPlayoffs
//
//  Created by Pierre-Marc Airoldi on 2015-06-23.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "StringHandler.h"

@implementation StringHandler

+(BOOL)compareString:(NSString *)string withRegex:(NSString *)regex {
    
    if (string == nil || regex == nil) {
        return false;
    }
    
    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error) {
        return false;
    }
    
    NSUInteger num = [expression numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (num == 1) {
        return true;
    }
    
    else {
        return false;
    }
}

@end
