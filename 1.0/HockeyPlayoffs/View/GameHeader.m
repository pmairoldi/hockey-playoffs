//
//  GameHeader.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-18.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "GameHeader.h"
#import "TeamImage.h"
#import "GameModel.h"
#import "TeamHandler.h"
#import "Colors.h"
#import "Dimensions.h"
#import "PeriodScoresView.h"
#import "PeriodScoreViewHeader.h"
#import "VideoButton.h"
#import "GameObject.h"
#import "GameOverviewView.h"
#import "ExpandedVideoView.h"

@interface GameHeader ()

@property GameOverviewView *gameOverview;
@property UIView *seperatorView;
@property UIView *topSeperator;
@property UIView *bottomSeperator;
@property PeriodScoresView *topPeriodScores;
@property PeriodScoresView *bottomPeriodScores;
@property PeriodScoreViewHeader *periodScoresHeader;

@property UIView *segmentBackground;

@end

@implementation GameHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

-(void)commonInit {
    
    self.contentView.backgroundColor = [Colors gameBackgroundColor];
    
    _topPeriodScores = [[PeriodScoresView alloc] init];
    
    _bottomPeriodScores = [[PeriodScoresView alloc] init];
    
    _periodScoresHeader = [[PeriodScoreViewHeader alloc] init];
    
    _sectionControl = [[UISegmentedControl alloc] initWithItems:[GameModel getSectionItems]];
    _sectionControl.tintColor = [Colors segmentTintColor];
    
    _segmentBackground = [[UIView alloc] init];
    _segmentBackground.backgroundColor = [Colors segmentBackgroundColor];
    
    _gameOverview = [[GameOverviewView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), [GameOverviewView height])];
    
    _videoButton = _gameOverview.videoButton;
    //        _videoView = _gameOverview.videoView;
    
    _seperatorView = [[UIView alloc] init];
    _seperatorView.backgroundColor = [Colors periodScoreSeperatorColor];
    
    _topSeperator = [[UIView alloc] init];
    _topSeperator.backgroundColor = [Colors periodScoreBackgroundColor];
    
    _bottomSeperator = [[UIView alloc] init];
    _bottomSeperator.backgroundColor = [Colors periodScoreBackgroundColor];
    
    [_seperatorView addSubview:_topPeriodScores];
    [_seperatorView addSubview:_bottomPeriodScores];
    [_seperatorView addSubview:_topSeperator];
    [_seperatorView addSubview:_bottomSeperator];
    
    [self.contentView addSubview:_gameOverview];
    [self.contentView addSubview:_periodScoresHeader];
    [self.contentView addSubview:_seperatorView];
    [self.contentView addSubview:_segmentBackground];
    [self.contentView addSubview:_sectionControl];
}


-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat height;
    
//    if (_gameOverview.videoView.isExpanded) {
//        height = [GameOverviewView height] + SHOW_VIDEO_OFFSET;
//    }
//    
//    else {
        height = [GameOverviewView height];
//    }
    
    _gameOverview.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), height);
    [_gameOverview layoutSubviews];

    _periodScoresHeader.frame = CGRectMake(0, CGRectGetMaxY(_gameOverview.frame), CGRectGetWidth(self.contentView.frame), PERIOD_SCORE_VIEW_HEADER_HEIGHT);
    
    CGFloat yOffset = 1.0/[[UIScreen mainScreen] scale];
    CGFloat labelHeight = PERIOD_SCORE_VIEW_HEIGHT - 2 * yOffset;

    _seperatorView.frame = CGRectMake(0, CGRectGetMaxY(_periodScoresHeader.frame), CGRectGetWidth(self.contentView.frame), 2*PERIOD_SCORE_VIEW_HEIGHT);
    
    _topSeperator.frame = CGRectMake(0, yOffset, CGRectGetWidth(_seperatorView.frame), yOffset);
    _bottomSeperator.frame = CGRectMake(0, CGRectGetHeight(_seperatorView.frame) - yOffset, CGRectGetWidth(_seperatorView.frame), yOffset);

    _topPeriodScores.frame = CGRectMake(0, yOffset, CGRectGetWidth(_seperatorView.frame), labelHeight);
    _bottomPeriodScores.frame = CGRectMake(0, CGRectGetMaxY(_topPeriodScores.frame) + 2 * yOffset, CGRectGetWidth(_seperatorView.frame), labelHeight);
    
    _segmentBackground.frame = CGRectMake(0, CGRectGetMaxY(_seperatorView.frame), CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(_seperatorView.frame));

    _sectionControl.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame) - 10, SECTION_CONTROL_HEIGHT);
    _sectionControl.center = CGPointMake(CGRectGetMidX(_segmentBackground.frame) + 1, CGRectGetMaxY(_seperatorView.frame) + CGRectGetHeight(_segmentBackground.frame)/2);
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    [self layoutSubviews];
}

+(CGFloat)height {
    
    return 200;
}

-(void)setGame:(GameModel *)game {
    
    [_topPeriodScores setScores:game ForTeam:game.homeTeam];
    [_bottomPeriodScores setScores:game ForTeam:game.awayTeam];
    [_periodScoresHeader setGame:game];
    
    [_gameOverview setGame:game.gameObject];

    [self layoutSubviews];
}

//-(void)isExpanded:(int)expandedIndex {
//    
//    [_gameOverview isExpanded:expandedIndex];
//}

@end
