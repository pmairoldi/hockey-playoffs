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
//#import "MPFoldTransition.h"
#import "ExpandedVideoView.h"

@interface GameOverviewView ()

@property UILabel *leftTeamLabel;
@property UILabel *rightTeamLabel;
@property TeamImage *leftTeamImage;
@property TeamImage *rightTeamImage;
@property UILabel *gameStatusLabel;
@property UILabel *rightScoreLabel;
@property UILabel *leftScoreLabel;
@property UILabel *gameLabel;

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
        
        _gameStatusLabel = [[UILabel alloc] init];
        [self setPropertiesForStatusLabel:_gameStatusLabel];
        
        _videoButton = [[VideoButton alloc] init];

        [_videoButton setAccessibilityIdentifier:[NSString stringWithFormat:@"Play Highlights"]];
        
        //        _videoView = [[ExpandedVideoView alloc] initWithFrame:CGRectMake(0, [[self class] height], CGRectGetWidth(self.frame), SHOW_VIDEO_OFFSET)];

        _gameLabel = [[UILabel alloc] init];
        [self setPropertiesForGameLabel:_gameLabel];

        [self addSubview:_leftTeamImage];
        [self addSubview:_leftTeamLabel];
        [self addSubview:_rightTeamImage];
        [self addSubview:_rightTeamLabel];
        [self addSubview:_gameStatusLabel];
        [self addSubview:_videoButton];
        [self addSubview:_leftScoreLabel];
        [self addSubview:_rightScoreLabel];
//        [self addSubview:_gameLabel];
        
//        [self addSubview:_videoView];
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (!_videoButton.enabled) {
        
        if (selected) {
            _videoButton.tintColor = [Colors videoButtonSelectedColor];
            self.backgroundColor = [Colors lightGrayColor];
        }
        
        else {
            [_videoButton setSelected:selected];
        }
    }
    
    if (selected) {
        self.backgroundColor = [Colors ultraLightGrayColor];
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
        self.backgroundColor = [Colors ultraLightGrayColor];
    }
    
    else {
        self.backgroundColor = [Colors gameBackgroundColor];
    }
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
//    _gameLabel.frame = CGRectMake(0, 0, 120, 12);
//    _gameLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(_gameLabel.frame)/2);
    
//    _videoView.frame = CGRectMake(0, [[self class] height], CGRectGetWidth(self.frame), SHOW_VIDEO_OFFSET);

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
    
    _gameStatusLabel.frame = CGRectMake(0, 5, CGRectGetMinX(_rightScoreLabel.frame) - CGRectGetMaxX(_leftScoreLabel.frame) - 2*2, TEAM_IMAGE_SIZE);
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

-(void)setGame:(GameObject *)game {
    
    [self setTeam:game.homeID withImage:_rightTeamImage andLabel:_rightTeamLabel];
    [self setTeam:game.awayID withImage:_leftTeamImage andLabel:_leftTeamLabel];
    
//    _gameLabel.text = [game getGameText];
    _gameStatusLabel.text = [game getGameStatus];
    
    _rightScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[game getScoreForTeam:game.homeID]];
    _leftScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[game getScoreForTeam:game.awayID]];
    
    [_videoButton setEnabled:[game hasVideo]];
    
//    [_videoView setEnabled:[game getEnabledVideos] withHomeTeam:game.homeID andAwayTeam:game.awayID];
    
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

//-(void)isExpanded:(int)expandedIndex {
//
//    if (expandedIndex != -1) {
//        _videoView.alpha = 0.0;
//        _videoView.isExpanded = YES;
//    }
//    
//    else {
//        _videoView.isExpanded = NO;
//    }
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        if (expandedIndex != -1) {
//            _videoView.alpha = 1.0;
//        }
//        
//        else {
//            _videoView.alpha = 0.0;
//        }
//        
//    } completion:^(BOOL finished) {
//        
//        if (expandedIndex != -1) {
//            _videoView.isExpanded = YES;
//        }
//        
//        else {
//            _videoView.isExpanded = NO;
//        }
//        
//    }];
//}

@end
