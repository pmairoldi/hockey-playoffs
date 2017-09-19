//
//  SeriesObject.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "SeriesObject.h"
#import "NSObject+PMDescription.h"

@implementation SeriesObject

-(id)init {
    
    self = [super init];
    
    if (self) {
        
        _seasonID = @"";
        _topTeam = @"";
        _bottomTeam = @"";
        _conference = @"";
    }

    return self;
}

-(NSString *)getSeriesID {
    
    int westOffset = 0;
    
    if ([_conference isEqualToString:@"w"]) {
        
        switch (_round) {
            case 1:
                westOffset = 4;
                break;
            case 2:
                westOffset = 2;
                break;
            case 3:
                westOffset = 1;
                break;
            default:
                westOffset = 0;
                break;
        }
    }
    
    return [NSString stringWithFormat:@"%@0%d%d%%", _seasonID, _round, _seed + westOffset];
}

-(NSString *)description {
    return [self pm_description];
}

@end
