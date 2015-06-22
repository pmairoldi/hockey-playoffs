//
//  PeriodScoresView.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-22.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "PeriodScoresView.h"
#import "Dimensions.h"
#import "Colours.h"
#import "GameModel.h"
#import "TeamHandler.h"

@interface PeriodScoresView ()

@property UILabel *periodOne;
@property UILabel *periodTwo;
@property UILabel *periodThree;
@property UILabel *periodOT;
@property UILabel *total;
@property UILabel *teamLabel;
@property UILabel *shotsLabel;

@end

@implementation PeriodScoresView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
        self.backgroundColor = PERIOD_SCORE_SEPERATOR_COLOUR;
        
        _teamLabel = [[UILabel alloc] init];
        [self setTeamLabelProperties:_teamLabel];
        
        _shotsLabel = [[UILabel alloc] init];
        [self setGameLabelProperties:_shotsLabel];
        
        _periodOne = [[UILabel alloc] init];
        [self setGameLabelProperties:_periodOne];
        
        _periodTwo = [[UILabel alloc] init];
        [self setGameLabelProperties:_periodTwo];
        
        _periodThree = [[UILabel alloc] init];
        [self setGameLabelProperties:_periodThree];
        
        _periodOT = [[UILabel alloc] init];
        [self setGameLabelProperties:_periodOT];
        
        _total = [[UILabel alloc] init];
        [self setGameLabelProperties:_total];
        
        [self addSubview:_periodOne];
        [self addSubview:_periodTwo];
        [self addSubview:_periodThree];
        [self addSubview:_periodOT];
        [self addSubview:_total];
        [self addSubview:_teamLabel];
        [self addSubview:_shotsLabel];
    }
    
    return self;
}

-(void)setScores:(GameModel *)game ForTeam:(NSString *)team {
    
    _teamLabel.text = [team uppercaseString];
    _teamLabel.backgroundColor = [TeamHandler getTeamColor:team];
    
    _shotsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[game getShotsForTeam:team]];
    _shotsLabel.backgroundColor = [TeamHandler getTeamColor:team];
    
    for (int i = 0; i < 5; ++i) {
        
        UILabel *label = [self getLabelAtIndex:i];
        
        if (i == 4) {
            
            label.text = [NSString stringWithFormat:@"%lu", (unsigned long)[game getScoreForTeam:team]];
        }
        
        else if (i == 3) {
            
            if ([game hasOTPeriod]) {
                label.text = [NSString stringWithFormat:@"%lu", (unsigned long)[game getScoreForTeam:team inPeriod:i + 1]];
            }
            
            else {
                label.text = @"";
            }
        }
        
        else {
            
            label.text = [NSString stringWithFormat:@"%lu", (unsigned long)[game getScoreForTeam:team inPeriod:i + 1]];
        }
        
        label.backgroundColor = [TeamHandler getTeamColor:team];
    }
    
}

-(UILabel *)getLabelAtIndex:(NSInteger)index {
    
    switch (index) {
            
        case 0:
            return _periodOne;
            break;
            
        case 1:
            return _periodTwo;
            break;
            
        case 2:
            return _periodThree;
            break;
            
        case 3:
            return _periodOT;
            break;
            
        case 4:
            return _total;
            break;
            
        default:
            return [[UILabel alloc] init];
            break;
    }
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat labelWidth = GAME_HEADER_SCORE_LABEL_WIDTH;
    CGFloat labelSpacing = SCORE_SPACEING;
    
    //1.0/[[UIScreen mainScreen] scale]
    CGFloat yOffset = 0;
    CGFloat labelHeight = self.frame.size.height - 2 * yOffset;
    
    _total.frame = CGRectMake(CGRectGetWidth(self.frame) - labelWidth, yOffset, labelWidth, labelHeight);
    
    if (_periodOT.text.length == 0) {
        
        _periodOT.frame = CGRectMake(CGRectGetMinX(_total.frame), yOffset, 0, 0);
    }
    
    else {
        _periodOT.frame = CGRectMake(CGRectGetMinX(_total.frame) - labelWidth - labelSpacing, yOffset, labelWidth, labelHeight);
    }
    
    _periodThree.frame = CGRectMake(CGRectGetMinX(_periodOT.frame) - labelWidth - labelSpacing, yOffset, labelWidth, labelHeight);
    
    _periodTwo.frame = CGRectMake(CGRectGetMinX(_periodThree.frame) - labelWidth - labelSpacing, yOffset, labelWidth, labelHeight);
    
    _periodOne.frame = CGRectMake(CGRectGetMinX(_periodTwo.frame) - labelWidth - labelSpacing, yOffset, labelWidth, labelHeight);
    
    _shotsLabel.frame = CGRectMake(CGRectGetMinX(_periodOne.frame) - labelWidth - labelSpacing, yOffset, labelWidth, labelHeight);
    
    _teamLabel.frame = CGRectMake(0, yOffset, CGRectGetMinX(_shotsLabel.frame) - labelSpacing, labelHeight);
    
}

-(void)setGameLabelProperties:(UILabel *)label {
    
    label.textColor = SERIES_TEAM_NAME_COLOUR;
    label.font = [UIFont boldSystemFontOfSize:SERIES_NAME_FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
}

-(void)setTeamLabelProperties:(UILabel *)label {
    
    label.textColor = SERIES_TEAM_NAME_COLOUR;
    label.font = [UIFont boldSystemFontOfSize:SERIES_NAME_FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
}

@end
