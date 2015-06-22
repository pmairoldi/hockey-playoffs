//
//  SeriesView.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-08.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "SeriesView.h"
#import "GameCell.h"
#import "SeriesHeader.h"
#import "ReuseIdentifiers.h"
#import "RefreshTableViewCell.h"
#import "NoDataTableViewCell.h"
#import "Colours.h"

@implementation SeriesView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        
        [self registerClass:[GameCell class] forCellReuseIdentifier:GAME_CELL_REUSE_IDENTIFIER];
        [self registerClass:[SeriesHeader class] forHeaderFooterViewReuseIdentifier:SERIES_HEADER_REUSE_IDENTIFIER];
        [self registerClass:[RefreshTableViewCell class] forCellReuseIdentifier:REFRESH_CELL_REUSE_IDENTIFIER];
        [self registerClass:[NoDataTableViewCell class] forCellReuseIdentifier:NO_DATA_CELL_REUSE_IDENTIFIER];
        
        self.noContentText = NSLocalizedString(@"series.nodata", nil);
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
