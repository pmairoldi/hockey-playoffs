//
//  SeriesViewController.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-04.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class SeriesObject;

@interface SeriesViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

-(id)initWithSeries:(SeriesObject *)series;

@end
