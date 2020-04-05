//
//  SeriesHeader.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-08.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import UIKit;

@class SeriesModel;

@interface SeriesHeader : UITableViewHeaderFooterView

+(CGFloat)height;

-(void)setSeries:(SeriesModel *)series;

@end
