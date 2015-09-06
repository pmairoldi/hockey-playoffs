//
//  SeriesHeader.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-08.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "SeriesHeader.h"
#import "SeriesModel.h"
#import "Dimensions.h"
#import "Colors.h"
#import "TeamHandler.h"
#import "SeriesHeaderScoresView.h"

@interface SeriesHeader ()

@property UILabel *topTeamLabel;
@property UILabel *bottomTeamLabel;
@property SeriesHeaderScoresView *topScoresView;
@property SeriesHeaderScoresView *bottomScoresView;
@property UIView *seperatorView;

@end

@implementation SeriesHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

-(void)commonInit {
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.contentView.backgroundColor = [Colors lightColor];
    
    _topTeamLabel = [[UILabel alloc] init];
    [self setTeamLabelProperties:_topTeamLabel];
    
    _bottomTeamLabel = [[UILabel alloc] init];
    [self setTeamLabelProperties:_bottomTeamLabel];
    
    _topScoresView = [[SeriesHeaderScoresView alloc] init];
    
    _bottomScoresView = [[SeriesHeaderScoresView alloc] init];
    
    [self.contentView addSubview:_topTeamLabel];
    [self.contentView addSubview:_bottomTeamLabel];
    
    [self.contentView addSubview:_topScoresView];
    [self.contentView addSubview:_bottomScoresView];
    
    _seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 1/[[UIScreen mainScreen] scale], self.contentView.frame.size.width, 1/[[UIScreen mainScreen] scale])];
    _seperatorView.backgroundColor = [Colors tableViewSeperatorColor];
    
    [self.contentView addSubview:_seperatorView];
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat strokeWidth = SERIES_STROKE_SIZE;
    CGRect insetRect = CGRectInset(CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - 1), strokeWidth, strokeWidth);
    
    CGRect sliceRect;
    CGRect remainderRect;
    
    CGRectDivide(insetRect, &sliceRect, &remainderRect, insetRect.size.height/2, CGRectMinYEdge);
    
    CGRect topTeamRect;
    CGRect topScoresRect;
    
    NSUInteger scoresWidth = 7*SERIES_GAME_LABEL_WIDTH + 6*SCORE_SPACEING + 1;
    
    CGRectDivide(sliceRect, &topScoresRect, &topTeamRect, scoresWidth, CGRectMaxXEdge);
    
    _topTeamLabel.frame = CGRectMake(topTeamRect.origin.x, topTeamRect.origin.y, topTeamRect.size.width, topTeamRect.size.height - 0.5);
    _topTeamLabel.backgroundColor = [TeamHandler getTeamColor:_topTeamLabel.text];
    
    _topScoresView.frame = CGRectMake(topScoresRect.origin.x + 1, topScoresRect.origin.y, topScoresRect.size.width - 1, topScoresRect.size.height - 0.5);
    
    CGRect bottomTeamRect;
    CGRect bottomScoresRect;
    
    CGRectDivide(remainderRect, &bottomScoresRect, &bottomTeamRect, scoresWidth, CGRectMaxXEdge);

    _bottomTeamLabel.frame = CGRectMake(bottomTeamRect.origin.x, bottomTeamRect.origin.y + 0.5, bottomTeamRect.size.width, bottomTeamRect.size.height - 0.5);
    _bottomTeamLabel.backgroundColor = [TeamHandler getTeamColor:_bottomTeamLabel.text];
    
    _bottomScoresView.frame = CGRectMake(bottomScoresRect.origin.x + 1, bottomScoresRect.origin.y + 0.5, bottomScoresRect.size.width - 1, bottomScoresRect.size.height - 0.5);
    
    _seperatorView.frame = CGRectMake(0, self.contentView.frame.size.height - 1/[[UIScreen mainScreen] scale], self.contentView.frame.size.width, 1/[[UIScreen mainScreen] scale]);
}

-(void)setTeamLabelProperties:(UILabel *)label {
    
    label.textColor = [Colors seriesTeamNameColor];
    label.font = [UIFont boldSystemFontOfSize:SERIES_NAME_FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [Colors lightGrayColor];
}

-(void)setSeries:(SeriesModel *)series {
    
    if ([series.topTeam isEqualToString:@""]) {
        _topTeamLabel.text = @"";
    }
    else {
        _topTeamLabel.text = [NSString stringWithFormat:@"%@ – %lu", [series.topTeam uppercaseString], (unsigned long)[series topWins]];
    }
    
    if ([series.bottomTeam isEqualToString:@""]) {
        _bottomTeamLabel.text = @"";
    }
    else {
        _bottomTeamLabel.text = [NSString stringWithFormat:@"%@ – %lu", [series.bottomTeam uppercaseString], (unsigned long)[series bottomWins]];
    }
    
    [_topScoresView setScores:[series getGames] ForTeam:series.topTeam];
    [_bottomScoresView setScores:[series getGames] ForTeam:series.bottomTeam];

    [self layoutSubviews];
}

- (void)prepareForReuse {
    
    [super prepareForReuse];

    [self layoutSubviews];
}

+(CGFloat)height {
    
    return 60;
}

@end
