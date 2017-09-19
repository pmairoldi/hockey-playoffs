//
//  BracketModel.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2/26/2014.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SeriesObject;

@interface BracketModel : NSObject

@property BOOL isRefreshing;

+(NSInteger)numberOfSections;
+(NSInteger)numberOfRowsInSection:(NSInteger)section;

-(SeriesObject *)getSeriesAtIndex:(NSIndexPath *)indexPath;
-(void)refresh:(void(^)(BOOL reload))completion;
-(BOOL)hasGameTodayAtIndex:(NSIndexPath *)indexPath;

@end
