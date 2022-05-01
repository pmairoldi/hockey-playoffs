//
//  GameOverviewView.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-27.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "GameOverviewView.h"
#import "TeamImage.h"
#import "VideoButton.h"
#import "GameObject.h"
#import "Colors.h"
#import "Dimensions.h"
#import "TeamHandler.h"

@interface GameOverviewView ()

@property UILabel *leftTeamLabel;
@property UILabel *rightTeamLabel;
@property TeamImage *leftTeamImage;
@property TeamImage *rightTeamImage;
@property UILabel *gameStatusLabel;
@property UILabel *rightScoreLabel;
@property UILabel *leftScoreLabel;
@property UILabel *rightStatusIndicatorLabel;
@property UILabel *leftStatusIndicatorLabel;

@end

@implementation GameOverviewView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clipsToBounds = YES;
        
        _leftTeamImage = [[TeamImage alloc] init];
        _rightTeamImage = [[TeamImage alloc] init];
        
        _leftTeamLabel = [[UILabel alloc] init];
        [self setPropertiesForTeamLabel:_leftTeamLabel];
        
        _rightTeamLabel = [[UILabel alloc] init];
        [self setPropertiesForTeamLabel:_rightTeamLabel];
        
        _leftScoreLabel = [[UILabel alloc] init];
        [self setPropertiesForScoreLabel:_leftScoreLabel];
        
        _rightScoreLabel = [[UILabel alloc] init];
        [self setPropertiesForScoreLabel:_rightScoreLabel];
        
        _rightStatusIndicatorLabel = [[UILabel alloc] init];
        [self setPropertiesForStatusIndicatorLabel:_rightStatusIndicatorLabel];
        
        _leftStatusIndicatorLabel = [[UILabel alloc] init];
        [self setPropertiesForStatusIndicatorLabel:_leftStatusIndicatorLabel];
        
        _gameStatusLabel = [[UILabel alloc] init];
        [self setPropertiesForStatusLabel:_gameStatusLabel];
        
        _videoButton = [[VideoButton alloc] init];
        [_videoButton setAccessibilityIdentifier:[NSString stringWithFormat:@"Play Highlights"]];
                        
        [self addSubview:_leftTeamImage];
        [self addSubview:_leftTeamLabel];
        [self addSubview:_rightTeamImage];
        [self addSubview:_rightTeamLabel];
        [self addSubview:_gameStatusLabel];
        [self addSubview:_videoButton];
        [self addSubview:_leftScoreLabel];
        [self addSubview:_rightScoreLabel];
        [self addSubview:_rightStatusIndicatorLabel];
        [self addSubview:_leftStatusIndicatorLabel];
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (!_videoButton.enabled) {
        if (selected) {
            _videoButton.tintColor = [Colors videoButtonSelectedColor];
        }
        
        else {
            [_videoButton setSelected:selected];
        }
    }
    
    if (selected) {
        self.backgroundColor = [Colors gameBackgroundSelectedColor];
    }
    
    else {
        self.backgroundColor = [Colors gameBackgroundColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    if (!_videoButton.enabled) {
        
        if (highlighted) {
            _videoButton.tintColor = [Colors videoButtonSelectedColor];
        }
        
        else {
            [_videoButton setHighlighted:highlighted];
        }
    }
    
    if (highlighted) {
        self.backgroundColor = [Colors gameBackgroundSelectedColor];
    }
    
    else {
        self.backgroundColor = [Colors gameBackgroundColor];
    }
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
        
    _leftTeamImage.frame = CGRectMake(IMAGE_X_OFFSET, 5, TEAM_IMAGE_SIZE, TEAM_IMAGE_SIZE);
    
    _rightTeamImage.frame = CGRectMake(CGRectGetWidth(self.frame) - TEAM_IMAGE_SIZE - IMAGE_X_OFFSET, 5, TEAM_IMAGE_SIZE, TEAM_IMAGE_SIZE);
    
    [_rightTeamLabel sizeToFit];
    
    _rightTeamLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(_rightTeamLabel.frame) - LABEL_X_OFFSET, CGRectGetMaxY(_rightTeamImage.frame) + 2, CGRectGetWidth(_rightTeamLabel.frame), CGRectGetHeight(_rightTeamLabel.frame));
    _rightTeamLabel.textAlignment = NSTextAlignmentRight;
    
    [_leftTeamLabel sizeToFit];
    
    _leftTeamLabel.frame = CGRectMake(LABEL_X_OFFSET, CGRectGetMaxY(_leftTeamImage.frame) + 2, CGRectGetWidth(_leftTeamLabel.frame), CGRectGetHeight(_leftTeamLabel.frame));
    _leftTeamLabel.textAlignment = NSTextAlignmentLeft;
    
    [_leftScoreLabel sizeToFit];
    
    _leftScoreLabel.frame = CGRectMake(CGRectGetMaxX(_leftTeamImage.frame) + 5, CGRectGetMinY(_leftTeamImage.frame), MIN(SCORE_LABEL_WIDTH, _leftScoreLabel.frame.size.width), CGRectGetHeight(_leftTeamImage.frame));
    
    [_rightScoreLabel sizeToFit];
    
    _rightScoreLabel.frame = CGRectMake(CGRectGetMinX(_rightTeamImage.frame) - MIN(SCORE_LABEL_WIDTH, _rightScoreLabel.frame.size.width) - 5, CGRectGetMinY(_rightTeamImage.frame), MIN(SCORE_LABEL_WIDTH, _rightScoreLabel.frame.size.width), CGRectGetHeight(_rightTeamImage.frame));
    
    [_leftStatusIndicatorLabel sizeToFit];
    
    _leftStatusIndicatorLabel.frame = CGRectMake(CGRectGetMaxX(_leftScoreLabel.frame) + 5, CGRectGetMinY(_leftScoreLabel.frame), MIN(SCORE_LABEL_WIDTH, _leftStatusIndicatorLabel.frame.size.width), CGRectGetHeight(_leftScoreLabel.frame));
    
    [_rightStatusIndicatorLabel sizeToFit];
    
    _rightStatusIndicatorLabel.frame = CGRectMake(CGRectGetMinX(_rightScoreLabel.frame) - MIN(SCORE_LABEL_WIDTH, _rightStatusIndicatorLabel.frame.size.width) - 5, CGRectGetMinY(_rightScoreLabel.frame), MIN(SCORE_LABEL_WIDTH, _rightStatusIndicatorLabel.frame.size.width), CGRectGetHeight(_rightScoreLabel.frame));
    
    _gameStatusLabel.frame = CGRectMake(0, 5, CGRectGetMinX(_rightStatusIndicatorLabel.frame) - CGRectGetMaxX(_leftStatusIndicatorLabel.frame) - 2*2, TEAM_IMAGE_SIZE);
    _gameStatusLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(_gameStatusLabel.frame)/2 + 5);
    
    _videoButton.frame = CGRectMake(0, 0, VIDEO_BUTTON_WIDTH, VIDEO_BUTTON_HEIGHT);
    _videoButton.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(_leftTeamLabel.frame));
    
}

+(CGFloat)height {
    
    return 96;
}

-(void)setPropertiesForScoreLabel:(UILabel *)label {
    
    label.textColor = [Colors gameCellScoreColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:SCORE_LABEL_FONT_SIZE];
    label.adjustsFontSizeToFitWidth = YES;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
}

-(void)setPropertiesForStatusLabel:(UILabel *)label {
    
    label.textColor = [Colors gameCellStatusTextColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:DETAIL_GAME_STATUS_FONT_SIZE];
    label.numberOfLines = 2;
    label.adjustsFontSizeToFitWidth = YES;
    label.lineBreakMode = NSLineBreakByWordWrapping;
}

-(void)setPropertiesForTeamLabel:(UILabel *)label {
    
    label.textColor = [Colors gameCellTeamTextColor];
    label.font = [UIFont systemFontOfSize:TEAM_LABEL_FONT_SIZE];
    label.numberOfLines = 2;
    label.adjustsFontSizeToFitWidth = YES;
    label.lineBreakMode = NSLineBreakByWordWrapping;
}

-(void)setPropertiesForGameLabel:(UILabel *)label {
    
    label.textColor = [Colors gameLabelTextColor];
    label.font = [UIFont systemFontOfSize:GAME_LABEL_FONT_SIZE];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
}

-(void)setPropertiesForStatusIndicatorLabel:(UILabel *)label {
    
    label.textColor = [Colors gameLabelTextColor];
    label.font = [UIFont boldSystemFontOfSize:TEAM_LABEL_FONT_SIZE];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    label.lineBreakMode = NSLineBreakByWordWrapping;
}

-(void)setGame:(GameObject *)game {
    
    [self setTeam:game.homeID withImage:_rightTeamImage andLabel:_rightTeamLabel];
    [self setTeam:game.awayID withImage:_leftTeamImage andLabel:_leftTeamLabel];
    
    _gameStatusLabel.text = [game getGameStatus];
    
    _rightScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[game getScoreForTeam:game.homeID]];
    _leftScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[game getScoreForTeam:game.awayID]];
    
    NSString *homeStatus = [[game homeStatus] uppercaseString];
    NSString *awayStatus = [[game awayStatus] uppercaseString];
    
    _rightStatusIndicatorLabel.attributedText = [self statusIndicatorString:homeStatus];
    _rightStatusIndicatorLabel.hidden = homeStatus.length == 0;
    
    _leftStatusIndicatorLabel.attributedText = [self statusIndicatorString:awayStatus];
    _leftStatusIndicatorLabel.hidden = awayStatus.length == 0;
    
    [_videoButton setEnabled:[game hasVideo]];
        
    [self layoutSubviews];
}

-(void)setTeam:(NSString *)team withImage:(TeamImage *)image andLabel:(UILabel *)label {
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@", [TeamHandler getTeamCity:team], [TeamHandler getTeamName:team]];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:label.textAlignment];
    [style setLineBreakMode:label.lineBreakMode];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: label.font, NSFontAttributeName, label.textColor, NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, nil];
    
    [label setFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMinY(label.frame), [text sizeWithAttributes:attributes].width, CGRectGetHeight(label.frame))];
    
    [image setLargeImage:team];
    [label setText:text];
}

-(NSAttributedString *)statusIndicatorString:(NSString *)statuses {
    
    NSMutableAttributedString *statusText = [[NSMutableAttributedString alloc] init];
    
    NSArray *array = [statuses componentsSeparatedByString:@","];
    for (NSString *item in array) {
        NSString *trimmedItem = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSDictionary *attributes;
        
        if ([[trimmedItem uppercaseString] isEqualToString:[@"pp" uppercaseString]]) {
            attributes = @{ NSForegroundColorAttributeName : [Colors powerplayColor] };
        } else if ([[trimmedItem uppercaseString] isEqualToString:[@"en" uppercaseString]]) {
            attributes = @{ NSForegroundColorAttributeName : [Colors emptyNetColor] };
        } else {
            attributes = @{ NSForegroundColorAttributeName : [Colors gameLabelTextColor] };
        }
        
        [statusText appendAttributedString: [[NSAttributedString alloc] initWithString:trimmedItem attributes:attributes]];
        if (![[array lastObject] isEqual:item]) {
            [statusText appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n"]];
        }
    }
        
    return statusText;
}

@end
