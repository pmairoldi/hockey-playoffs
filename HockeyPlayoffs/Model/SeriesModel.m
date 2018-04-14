//
//  SeriesModel.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-07.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "SeriesModel.h"
#import "SeriesObject.h"
#import "GameObject.h"
#import "DatabaseHandler.h"
#import "Queues.h"
#import "NoDataTableViewCell.h"
#import "RefreshTableViewCell.h"
#import "GameCell.h"
#import "Dimensions.h"

@interface SeriesModel ()

@property SeriesObject *seriesObject;
@property NSArray *games;

@end

@implementation SeriesModel

-(id)init {
    
    self = [super init];
    
    if (self) {
        
        _seriesObject = [[SeriesObject alloc] init];
        _games = [NSArray array];
        
        _expandedIndex = -1;
    }
    
    return self;
}

+(instancetype)initWithSeries:(SeriesObject *)series {
    
    SeriesModel *model = [[SeriesModel alloc] init];
    
    model.seriesObject = series;
        
    return model;
}

-(BOOL)hasData {
    
    if ([_games count] > 0) {
        return YES;
    }
    
    else {
        return NO;
    }
}

-(BOOL)hasTeams {
    
    if ([[self topTeam] isEqualToString:@""] && [[self bottomTeam] isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

-(void)setExpandedIndex:(int)index {
    
    if (_expandedIndex == index) {
        _expandedIndex = -1;
    }
    
    else {
        _expandedIndex = index;
    }
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
        return [_games count];
    }
}

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && _isRefreshing && self.games.count <= 0) {
        
        return [RefreshTableViewCell height];
    }
    
    else if (indexPath.section == 0 && !_isRefreshing) {
        
        return [NoDataTableViewCell height];
    }
    
    else {
        
        CGFloat offset = 0;
        
        if (_expandedIndex != -1 && _expandedIndex < [self numberOfRowsInSection:indexPath.section] && _expandedIndex == indexPath.row) {
            offset = SHOW_VIDEO_OFFSET;
        }
        
        return [GameCell height] + offset;
    }
}

-(CGFloat)estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && _isRefreshing && self.games.count <= 0) {
        
        return [RefreshTableViewCell height];
    }
    
    else if (indexPath.section == 0 && !_isRefreshing) {
        
        return [NoDataTableViewCell height];
    }
    
    else {
        return [GameCell height];
    }
}

-(NSUInteger)topWins {
    
    return _seriesObject.topWins;
}

-(NSUInteger)bottomWins {
    
    return _seriesObject.bottomWins;
}

-(GameObject *)getGameAtIndex:(NSIndexPath *)indexPath {
    
    if (indexPath.row < _games.count) {
        
        return [_games objectAtIndex:indexPath.row];
    }
    
    else {
        
        return [[GameObject alloc] init];
    }
}

-(NSString *)getControllerTitle {
    
    NSString *localizedRoundTitle;
    
    switch (_seriesObject.round) {
            
        case 1:
            
            if ([_seriesObject.conference isEqualToString:@"w"]) {
                
                localizedRoundTitle = @"controller.bracket.quarter.west";
            }
            
            else if ([_seriesObject.conference isEqualToString:@"e"]) {
                
                localizedRoundTitle = @"controller.bracket.quarter.east";
            }
            
            else {
                localizedRoundTitle = @"";
            }
            
            break;
            
        case 2:
            
            if ([_seriesObject.conference isEqualToString:@"w"]) {
                
                localizedRoundTitle = @"controller.bracket.semi.west";
            }
            
            else if ([_seriesObject.conference isEqualToString:@"e"]) {
                
                localizedRoundTitle = @"controller.bracket.semi.east";
            }
            
            else {
                localizedRoundTitle = @"";
            }
            
            break;
            
        case 3:
            
            if ([_seriesObject.conference isEqualToString:@"w"]) {
                
                localizedRoundTitle = @"controller.bracket.final.west";
            }
            
            else if ([_seriesObject.conference isEqualToString:@"e"]) {
                
                localizedRoundTitle = @"controller.bracket.final.east";
            }
            
            else {
                localizedRoundTitle = @"";
            }
            
            break;
            
        case 4:
            
            localizedRoundTitle = @"controller.bracket.final";
            break;
            
        default:
            localizedRoundTitle = @"";
            break;
    }
    
    return NSLocalizedString(localizedRoundTitle, nil);
}

-(NSString *)topTeam {
    
    return _seriesObject.topTeam;
}

-(NSString *)bottomTeam {
    
    return _seriesObject.bottomTeam;
}

-(NSArray *)getGames {
    
    return _games;
}

-(void)refresh {

    _seriesObject = [DatabaseHandler getSeriesForRound:_seriesObject.round seed:_seriesObject.seed conference:_seriesObject.conference seasonID:_seriesObject.seasonID];
    _games = [DatabaseHandler getGamesForSeries:_seriesObject];
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
