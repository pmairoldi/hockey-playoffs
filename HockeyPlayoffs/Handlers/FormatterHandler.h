//
//  FormatterHandler.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-08.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;

@interface FormatterHandler : NSObject

+(NSDateFormatter *)fullDateFormatter;
+(NSDateFormatter *)fullDateTimeFormatter;
+(NSDateFormatter *)longDateFormatter;
+(NSDateFormatter *)timeFormatter;

@end

