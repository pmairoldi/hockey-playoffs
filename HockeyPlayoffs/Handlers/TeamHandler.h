//
//  TeamHandler.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2013-09-29.
//  Copyright (c) 2013 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface TeamHandler : NSObject

+(NSString *)getTeamCity:(NSString *)teamABR;
+(NSString *)getTeamName:(NSString *)teamABR;
+(NSString *)getTeamABR:(NSString *)teamName;
+(UIColor *)getTeamColor:(NSString *)teamABR;

@end
