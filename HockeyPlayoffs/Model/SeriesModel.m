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
    }
    
    return self;
}

+(instancetype)initWithSeries:(SeriesObject *)series {
    
    SeriesModel *model = [[SeriesModel alloc] init];
    
    model.seriesObject = series;
        
    return model;
}

-(BOOL)hasData {

    if ([self.games count] > 0) {
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

-(NSInteger)numberOfSections {
    
    return 2;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {

        if (self.isRefreshing) {
            return 1;
        }

        else {
            return 0;
        }
    }

    else {
        return [self.games count];
    }
}

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && self.isRefreshing && self.games.count <= 0) {

        return [RefreshTableViewCell height];
    }

    else if (indexPath.section == 0 && !self.isRefreshing) {

        return [NoDataTableViewCell height];
    }

    else {
        return [GameCell height];
    }
}

-(CGFloat)estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && self.isRefreshing && self.games.count <= 0) {

        return [RefreshTableViewCell height];
    }

    else if (indexPath.section == 0 && !self.isRefreshing) {

        return [NoDataTableViewCell height];
    }

    else {
        return [GameCell height];
    }
}

-(NSUInteger)topWins {

    return self.seriesObject.topWins;
}

-(NSUInteger)bottomWins {

    return self.seriesObject.bottomWins;
}

-(GameObject *)getGameAtIndex:(NSIndexPath *)indexPath {

    NSArray *games = self.games;

    if (indexPath.row < games.count) {

        return [games objectAtIndex:indexPath.row];
    }

    else {

        return [[GameObject alloc] init];
    }
}

-(NSString *)getControllerTitle {

    SeriesObject *series = self.seriesObject;
    NSString *localizedRoundTitle;

    switch (series.round) {

        case 1:

            if ([series.conference isEqualToString:@"w"]) {

                localizedRoundTitle = @"controller.bracket.quarter.west";
            }

            else if ([series.conference isEqualToString:@"e"]) {

                localizedRoundTitle = @"controller.bracket.quarter.east";
            }

            else {
                localizedRoundTitle = @"";
            }

            break;

        case 2:

            if ([series.conference isEqualToString:@"w"]) {

                localizedRoundTitle = @"controller.bracket.semi.west";
            }

            else if ([series.conference isEqualToString:@"e"]) {

                localizedRoundTitle = @"controller.bracket.semi.east";
            }

            else {
                localizedRoundTitle = @"";
            }

            break;

        case 3:

            if ([series.conference isEqualToString:@"w"]) {

                localizedRoundTitle = @"controller.bracket.final.west";
            }

            else if ([series.conference isEqualToString:@"e"]) {

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

    return self.seriesObject.topTeam;
}

-(NSString *)bottomTeam {

    return self.seriesObject.bottomTeam;
}

-(NSArray *)getGames {

    return self.games;
}

-(void)refresh {

    SeriesObject *current = self.seriesObject;
    SeriesObject *updated = [DatabaseHandler getSeriesForRound:current.round seed:current.seed conference:current.conference seasonID:current.seasonID];

    self.seriesObject = updated;
    self.games = [DatabaseHandler getGamesForSeries:updated];
}

-(void)refresh:(void(^)(BOOL reload))completion {

    self.isRefreshing = YES;

    if (completion == nil) {

        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

        dispatch_async(DB_FETCH_QUEUE, ^{

            [self refresh];

            dispatch_semaphore_signal(semaphore);
        });

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        self.isRefreshing = NO;
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
