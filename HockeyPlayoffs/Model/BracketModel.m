//
//  BracketModel.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2/26/2014.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "BracketModel.h"
#import "SeriesObject.h"
#import "DatabaseHandler.h"
#import "Queues.h"
#import "DateTimeHandler.h"

@interface BracketModel ()

@property NSArray *seriesArray;

@end

@implementation BracketModel

-(id)init {
    
    self = [super init];
    
    if (self) {

//        [self refresh:nil];
    }

    return self;
}

+(NSInteger)numberOfSections {

    return 7;
}

+(NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 4;
            break;
            
        case 1:
            return 2;
            break;
            
        case 2:
            return 1;
            break;
            
        case 3:
            return 1;
            break;
            
        case 4:
            return 1;
            break;
            
        case 5:
            return 2;
            break;
            
        case 6:
            return 4;
            break;
            
        default:
            return 0;
            break;
    }
}

-(SeriesObject *)getSeriesAtIndex:(NSIndexPath *)indexPath {

    int index = 2*(int)indexPath.section + (int)indexPath.row;

    switch (indexPath.section) {
        
        case 1:
        case 2:
            index += 2;
            break;
        
        case 3:
            index += 1;
            break;
        
        case 5:
        case 6:
            index -= 1;
            break;
            
        default:
            break;
    }
    
    NSString *conference;
    short round;
    short seed;
    
    if ((index >= 0 && index < 4) || (index >= 11 && index < 15)) {
    
        int offsetIndex;

        if (index >= 0 && index < 4) {
            conference = @"w";
            offsetIndex = index;
        }
        
        else {
            conference = @"e";
            offsetIndex = index - 11;
        }
        
        round = 1;
        
        switch (offsetIndex) {
            case 0:
                seed = 1;
                break;
            case 1:
                seed = 2;
                break;
            case 2:
                seed = 3;
                break;
            case 3:
                seed = 4;
                break;
            default:
                seed = 0;
                break;
        }
    }
    
    else if ((index >= 4 && index < 6) || (index >= 9 && index < 11)) {
        
        int offsetIndex;
        
        if (index >= 4 && index < 6) {
            conference = @"w";
            offsetIndex = index - 4;
        }
        
        else {
            conference = @"e";
            offsetIndex = index - 9;
        }
        
        round = 2;
        
        switch (offsetIndex) {
            case 0:
                seed = 1;
                break;
            case 1:
                seed = 2;
                break;
            default:
                seed = 0;
                break;
        }
    }

    else if (index == 6 || index == 8) {
        
        if (index == 6) {
            conference = @"w";
        }
        
        else {
            conference = @"e";
        }
        
        round = 3;
        seed = 1;
    }
    
    else if (index == 7) {
        
        conference = @"f";
        round = 4;
        seed = 1;
    }
    
    else {
        conference = @"";
        round = 0;
        seed = 0;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"conference MATCHES %@ AND seed == %d AND round == %d", conference, seed, round];
    
    if (predicate) {
        SeriesObject *object = [[_seriesArray filteredArrayUsingPredicate:predicate] firstObject];
        return object;
    }
    
    else {
        return nil;
    }
}

-(BOOL)hasGameTodayAtIndex:(NSIndexPath *)indexPath {
    
    SeriesObject *series = [self getSeriesAtIndex:indexPath];
    
    if (series != nil) {
        
        if (series.hasGameToday) {
            return YES;
        }
        
        else {
            return NO;
        }
    }
    
    else {
        return NO;
    }
}

-(void)refresh {
    
    _seriesArray = [DatabaseHandler getPlayoffsTree];
}

-(void)refresh:(void(^)(BOOL reload))completion {
    
    _isRefreshing = YES;

    if (completion == nil) {
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        dispatch_async(DB_FETCH_QUEUE, ^{
            
            [self refresh];
            
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
        _isRefreshing = NO;
    }
    
    else {
        
        dispatch_async(DB_FETCH_QUEUE, ^{
            
            [self refresh];
            
            self.isRefreshing = NO;

            dispatch_async(dispatch_get_main_queue(), ^{
                completion(YES);
            });
        });
    }
}

@end
