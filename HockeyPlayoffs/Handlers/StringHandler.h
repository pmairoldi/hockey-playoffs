//
//  StringHandler.h
//  HockeyPlayoffs
//
//  Created by Pierre-Marc Airoldi on 2015-06-23.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;

@interface StringHandler : NSObject

+(BOOL)compareString:(NSString *)string withRegex:(NSString *)regex;

@end
