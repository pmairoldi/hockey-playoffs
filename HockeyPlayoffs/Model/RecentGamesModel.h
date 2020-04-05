//
//  RecentGamesModel.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-07.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;

@class GameObject;

@interface RecentGamesModel : NSObject

@property BOOL isRefreshing;
@property NSDate *date;

-(NSInteger)numberOfSections;
-(NSInteger)numberOfRowsInSection:(NSInteger)section;
-(NSArray *)getGames;
-(GameObject *)getGameAtIndex:(NSIndexPath *)indexPath;
-(BOOL)hasData;
+(NSArray *)getSectionItems;

-(void)refresh:(void(^)(BOOL reload))completion;

@end
