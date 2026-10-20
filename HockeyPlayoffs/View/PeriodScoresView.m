//
//  PeriodScoresView.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-22.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "PeriodScoresView.h"
#import "ScoreGridLayout.h"
#import "Dimensions.h"
#import "Colors.h"
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
        
        self.backgroundColor = [Colors periodScoreSeperatorColor];
        
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
    [self setNeedsLayout];
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
    
    BOOL overtime = _periodOT.text.length > 0;
    _periodOT.hidden = !overtime;
    NSArray<UILabel *> *labels = overtime ?
        @[_teamLabel, _shotsLabel, _periodOne, _periodTwo, _periodThree, _periodOT, _total] :
        @[_teamLabel, _shotsLabel, _periodOne, _periodTwo, _periodThree, _total];
    ScoreGridLayout layout = ScoreGridLayoutMake(CGRectGetWidth(self.bounds), labels.count - 1,
                                                 44, 80, self.traitCollection);
    _teamLabel.frame = CGRectMake(0, 0, layout.teamWidth, CGRectGetHeight(self.bounds));
    for (NSUInteger i = 1; i < labels.count; i++) {
        labels[i].frame = ScoreGridNumericFrame(layout, i - 1, CGRectGetHeight(self.bounds));
    }
    
}

-(void)setGameLabelProperties:(UILabel *)label {
    label.textColor = [Colors seriesTeamNameColor];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    label.adjustsFontForContentSizeCategory = YES;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
}

-(void)setTeamLabelProperties:(UILabel *)label {
    [self setGameLabelProperties:label];
}

@end
