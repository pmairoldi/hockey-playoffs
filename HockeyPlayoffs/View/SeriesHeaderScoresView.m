//
//  SeriesHeaderScoresView.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-09.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "SeriesHeaderScoresView.h"
#import "Dimensions.h"
#import "Colours.h"
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

@end

@implementation SeriesHeaderScoresView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
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
    }
    
    return self;
}

-(void)setScores:(NSArray *)scores ForTeam:(NSString *)team {

    for (int i = 0; i < [scores count]; ++i) {
        
        GameObject *game = [scores objectAtIndex:i];
        
        UILabel *label = [self getLabelAtIndex:i];
        
        label.text = [NSString stringWithFormat:@"%lu", (unsigned long)[game getScoreForTeam:team]];
        
        if ([game hasWonGame:team]) {
    
            label.backgroundColor = [TeamHandler getTeamColor:team];
        }
        
        else {
            
            label.backgroundColor = LIGHT_GRAY_COLOUR;
        }
    }
    
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
    
    CGFloat labelWidth = SERIES_GAME_LABEL_WIDTH;
    CGFloat labelSpacing = SCORE_SPACEING;
    
    CGFloat labelHeight = self.frame.size.height;
    
    _gameOne.frame = CGRectMake(0, 0, labelWidth, labelHeight);
    
    _gameTwo.frame = CGRectMake(_gameOne.frame.origin.x + _gameOne.frame.size.width + labelSpacing, 0, labelWidth, labelHeight);
    
    _gameThree.frame = CGRectMake(_gameTwo.frame.origin.x + _gameTwo.frame.size.width + labelSpacing, 0, labelWidth, labelHeight);
    
    _gameFour.frame = CGRectMake(_gameThree.frame.origin.x + _gameThree.frame.size.width + labelSpacing, 0, labelWidth, labelHeight);
    
    _gameFive.frame = CGRectMake(_gameFour.frame.origin.x + _gameFour.frame.size.width + labelSpacing, 0, labelWidth, labelHeight);
    
    _gameSix.frame = CGRectMake(_gameFive.frame.origin.x + _gameFive.frame.size.width + labelSpacing, 0, labelWidth, labelHeight);
    
    _gameSeven.frame = CGRectMake(_gameSix.frame.origin.x + _gameSix.frame.size.width + labelSpacing, 0, labelWidth, labelHeight);
}

-(void)setGameLabelProperties:(UILabel *)label {
    
    label.textColor = SERIES_TEAM_NAME_COLOUR;
    label.font = [UIFont boldSystemFontOfSize:SERIES_NAME_FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = LIGHT_GRAY_COLOUR;
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
