//
//  SeriesCell.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2/26/2014.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import UIKit;

@class SeriesObject;

@interface SeriesCell : UICollectionViewCell

-(void)setSeries:(SeriesObject *)series;
-(void)setTodayIndicator:(BOOL)hasGameToday;
-(void)setRefresh:(BOOL)refresh;

@end
