//
//  RecentGamesModel.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-07.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "RecentGamesModel.h"
#import "SeriesObject.h"
#import "GameObject.h"
#import "DatabaseHandler.h"
#import "Queues.h"
#import "DateTimeHandler.h"

@interface RecentGamesModel ()

@property NSArray *games;

@end

@implementation RecentGamesModel

-(id)init {
    
    self = [super init];
    
    if (self) {
        
        _games = [NSArray array];
        _date = [NSDate date];
        
//        [self refresh:nil];
    }
    
    return self;
}

-(BOOL)hasData {
    
    if ([[self getGamesForDate] count] > 0) {
        return YES;
    }
    
    else {
        return NO;
    }
}

-(NSString *)getStringDateForTab {
    
    NSString *stringDate = [DateTimeHandler getStringForDate:_date];
    
    return stringDate;
}

-(NSArray *)getGamesForDate {
    
    [self refresh];
    
    return _games;
}

-(NSInteger)numberOfSections {
    
    return 2;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if (_isRefreshing) {
            return 1;
        }
        
        else {
            return 0;
        }
    }
    
    else {
        
        NSInteger rows = [[self getGamesForDate] count];
        
        return rows;
    }
}

-(GameObject *)getGameAtIndex:(NSIndexPath *)indexPath {
    
    if (indexPath.row < [self getGamesForDate].count) {
        
        return [[self getGamesForDate] objectAtIndex:indexPath.row];
    }
    
    else {
        
        return [[GameObject alloc] init];
    }
}

-(NSArray *)getGames {
    
    return [self getGamesForDate];
}

+(NSArray *)getSectionItems {
    
    return [NSArray arrayWithObjects:NSLocalizedString(@"recent.yesterday", nil), NSLocalizedString(@"recent.today", nil), NSLocalizedString(@"recent.tomorrow", nil), nil];
}

-(void)refresh {

    _games = [DatabaseHandler getGamesForDate:_date];
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
            
            _isRefreshing = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(YES);
            });
        });
    }
}

@end