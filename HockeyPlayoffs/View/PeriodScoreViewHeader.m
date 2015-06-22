//
//  PeriodScoreViewHeader.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-27.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "PeriodScoreViewHeader.h"
#import "Dimensions.h"
#import "Colours.h"
#import "GameModel.h"

@interface PeriodScoreViewHeader ()

@property UILabel *periodOne;
@property UILabel *periodTwo;
@property UILabel *periodThree;
@property UILabel *periodOT;
@property UILabel *total;
@property UILabel *shotsLabel;

@end

@implementation PeriodScoreViewHeader

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
//        self.backgroundColor = PERIOD_SCORE_BACKGROUND_COLOUR;
        
        _shotsLabel = [[UILabel alloc] init];
        _shotsLabel.text = NSLocalizedString(@"SOG", nil);
        
        [self setGameLabelProperties:_shotsLabel];
        
        _periodOne = [[UILabel alloc] init];
        _periodOne.text = @"1";
        
        [self setGameLabelProperties:_periodOne];
        
        _periodTwo = [[UILabel alloc] init];
        _periodTwo.text = @"2";

        [self setGameLabelProperties:_periodTwo];
        
        _periodThree = [[UILabel alloc] init];
        _periodThree.text = @"3";

        [self setGameLabelProperties:_periodThree];
        
        _periodOT = [[UILabel alloc] init];

        [self setGameLabelProperties:_periodOT];
        
        _total = [[UILabel alloc] init];
        _total.text = NSLocalizedString(@"T", nil);

        [self setGameLabelProperties:_total];
        
        [self addSubview:_periodOne];
        [self addSubview:_periodTwo];
        [self addSubview:_periodThree];
        [self addSubview:_periodOT];
        [self addSubview:_total];
        [self addSubview:_shotsLabel];
    }
    
    return self;
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
    
    CGFloat yOffset = 1.0/[[UIScreen mainScreen] scale];
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
}

-(void)setGameLabelProperties:(UILabel *)label {
    
    label.textColor = PERIOD_SCORE_VIEW_HEADER_FONT_COLOUR;
    label.font = [UIFont systemFontOfSize:PERIOD_SCORE_VIEW_HEADER_FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
}

-(void)setGame:(GameModel *)game {
    
    if ([game hasOTPeriod]) {
        
        if ([game otPeriod] == 1) {
         
            _periodOT.text = NSLocalizedString(@"OT", nil);
        }
        
        else {
            
            _periodOT.text = [NSString stringWithFormat:@"%d%@", [game otPeriod], NSLocalizedString(@"OT", nil)];
        }
    }
    
    else {
        _periodOT.text = @"";
    }
}

@end
