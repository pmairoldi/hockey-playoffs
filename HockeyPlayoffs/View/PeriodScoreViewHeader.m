//
//  PeriodScoreViewHeader.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-27.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "PeriodScoreViewHeader.h"
#import "ScoreGridLayout.h"
#import "Dimensions.h"
#import "Colors.h"
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
    
    BOOL overtime = _periodOT.text.length > 0;
    _periodOT.hidden = !overtime;
    NSArray<UILabel *> *labels = overtime ?
        @[_shotsLabel, _periodOne, _periodTwo, _periodThree, _periodOT, _total] :
        @[_shotsLabel, _periodOne, _periodTwo, _periodThree, _total];
    ScoreGridLayout layout = ScoreGridLayoutMake(CGRectGetWidth(self.bounds), labels.count,
                                                 44, 80, self.traitCollection);
    for (NSUInteger i = 0; i < labels.count; i++) {
        labels[i].frame = ScoreGridNumericFrame(layout, i, CGRectGetHeight(self.bounds));
    }
}

-(void)setGameLabelProperties:(UILabel *)label {
    
    label.textColor = [Colors periodScoreViewHeaderFontColor];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    label.adjustsFontForContentSizeCategory = YES;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
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
    [self setNeedsLayout];
}

@end
