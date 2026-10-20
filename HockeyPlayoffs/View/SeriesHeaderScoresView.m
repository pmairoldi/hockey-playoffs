//
//  SeriesHeaderScoresView.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-09.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "SeriesHeaderScoresView.h"
#import "Dimensions.h"
#import "Colors.h"
#import "GameModel.h"
#import "TeamHandler.h"
#import "GameObject.h"

@interface SeriesHeaderScoresView ()

@property UILabel *gameOne;
@property UILabel *gameTwo;
@property UILabel *gameThree;
@property UILabel *gameFour;
@property UILabel *gameFive;
@property UILabel *gameSix;
@property UILabel *gameSeven;
@property UIView *trailingBackground;

@end

@implementation SeriesHeaderScoresView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _gameOne = [[UILabel alloc] init];
        [self setGameLabelProperties:_gameOne];
        
        _gameTwo = [[UILabel alloc] init];
        [self setGameLabelProperties:_gameTwo];
        
        _gameThree = [[UILabel alloc] init];
        [self setGameLabelProperties:_gameThree];
        
        _gameFour = [[UILabel alloc] init];
        [self setGameLabelProperties:_gameFour];
        
        _gameFive = [[UILabel alloc] init];
        [self setGameLabelProperties:_gameFive];
        
        _gameSix = [[UILabel alloc] init];
        [self setGameLabelProperties:_gameSix];
        
        _gameSeven = [[UILabel alloc] init];
        [self setGameLabelProperties:_gameSeven];
        
        [self addSubview:_gameOne];
        [self addSubview:_gameTwo];
        [self addSubview:_gameThree];
        [self addSubview:_gameFour];
        [self addSubview:_gameFive];
        [self addSubview:_gameSix];
        [self addSubview:_gameSeven];
        _trailingBackground = [[UIView alloc] init];
        _trailingBackground.backgroundColor = _gameSeven.backgroundColor;
        [self addSubview:_trailingBackground];
    }
    
    return self;
}

-(void)setScores:(NSArray *)scores ForTeam:(NSString *)team {

    for (NSInteger i = 0; i < 7; i++) {
        UILabel *label = [self getLabelAtIndex:i];
        label.text = @"";
        label.backgroundColor = [Colors seriesTeamNameBackgroundColor];
        label.textColor = [Colors seriesTeamNameColor];
    }
    for (NSInteger i = 0; i < MIN(scores.count, 7); ++i) {
        
        GameObject *game = [scores objectAtIndex:i];
        
        UILabel *label = [self getLabelAtIndex:i];
        
        label.text = [NSString stringWithFormat:@"%lu", (unsigned long)[game getScoreForTeam:team]];
        
        if ([game hasWonGame:team]) {
            label.backgroundColor = [TeamHandler getTeamColor:team];
            label.textColor = [Colors seriesTeamNameColor];
        }
        
        else {
            label.backgroundColor = [Colors seriesTeamNameBackgroundColor];
            label.textColor = [Colors seriesTeamNameColor];
        }
    }
    _trailingBackground.backgroundColor = _gameSeven.backgroundColor;
    [self setNeedsLayout];
}

-(UILabel *)getLabelAtIndex:(NSInteger)index {
    
    switch (index) {
    
        case 0:
            return _gameOne;
            break;
        
        case 1:
            return _gameTwo;
            break;
            
        case 2:
            return _gameThree;
            break;
            
        case 3:
            return _gameFour;
            break;
            
        case 4:
            return _gameFive;
            break;
            
        case 5:
            return _gameSix;
            break;
            
        case 6:
            return _gameSeven;
            break;

        default:
            return [[UILabel alloc] init];
            break;
    }
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat scale = MAX(self.traitCollection.displayScale, 1.0);
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat inset = MIN(width, MAX(0, round(self.trailingContentInset * scale) / scale));
    CGFloat usablePixels = MAX(0, round((width - inset) * scale) - 6);
    for (NSUInteger i = 0; i < 7; i++) {
        CGFloat start = round(i * usablePixels / 7) + i;
        CGFloat end = round((i + 1) * usablePixels / 7) + i;
        [self getLabelAtIndex:i].frame = CGRectMake(start / scale, 0, (end - start) / scale, CGRectGetHeight(self.bounds));
    }
    _trailingBackground.frame = CGRectMake(width - inset, 0, inset, CGRectGetHeight(self.bounds));
}

-(void)setGameLabelProperties:(UILabel *)label {
    label.textColor = [Colors seriesTeamNameColor];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    label.adjustsFontForContentSizeCategory = YES;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.6;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [Colors seriesTeamNameBackgroundColor];
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
