//
//  GameView.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-18.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "GameView.h"
#import "ReuseIdentifiers.h"
#import "GameHeader.h"
#import "GameDetailCell.h"
#import "GameDetailHeader.h"
#import "RefreshTableViewCell.h"
#import "NoDataTableViewCell.h"

@implementation GameView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        
        [self registerClass:[GameDetailCell class] forCellReuseIdentifier:GAME_DETAIL_CELL_REUSE_IDENTIFIER];
        [self registerClass:[GameHeader class] forHeaderFooterViewReuseIdentifier:GAME_HEADER_REUSE_IDENTIFIER];
        [self registerClass:[GameDetailHeader class] forHeaderFooterViewReuseIdentifier:GAME_DETAIL_HEADER_REUSE_IDENTIFIER];
        [self registerClass:[RefreshTableViewCell class] forCellReuseIdentifier:REFRESH_CELL_REUSE_IDENTIFIER];
        [self registerClass:[NoDataTableViewCell class] forCellReuseIdentifier:NO_DATA_CELL_REUSE_IDENTIFIER];
    }
    
    return self;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
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
