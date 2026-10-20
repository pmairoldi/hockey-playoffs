#import "GameHeader.h"
#import "GameModel.h"
#import "GameOverviewView.h"
#import "PeriodScoresView.h"
#import "PeriodScoreViewHeader.h"
#import "VideoButton.h"
#import "Colors.h"

@interface GameHeader ()
@property GameOverviewView *gameOverview;
@property PeriodScoresView *topPeriodScores;
@property PeriodScoresView *bottomPeriodScores;
@property PeriodScoreViewHeader *periodScoresHeader;
@property UIView *segmentBackground;
@end

@implementation GameHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    self.contentView.backgroundColor = [Colors gameBackgroundColor];
    self.contentView.layer.cornerRadius = 24;
    self.contentView.layer.cornerCurve = kCACornerCurveContinuous;
    self.contentView.clipsToBounds = YES;
    _gameOverview = [[GameOverviewView alloc] initWithFrame:CGRectZero];
    _videoButton = _gameOverview.videoButton;
    _topPeriodScores = [[PeriodScoresView alloc] init];
    _bottomPeriodScores = [[PeriodScoresView alloc] init];
    _periodScoresHeader = [[PeriodScoreViewHeader alloc] init];
    _sectionControl = [[UISegmentedControl alloc] initWithItems:[GameModel getSectionItems]];
    _sectionControl.tintColor = [Colors tintColor];
    _segmentBackground = [[UIView alloc] init];
    _segmentBackground.backgroundColor = [Colors segmentBackgroundColor];
    for (UIView *view in @[_gameOverview, _periodScoresHeader, _topPeriodScores, _bottomPeriodScores, _segmentBackground, _sectionControl]) {
        [self.contentView addSubview:view];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat pixel = 1.0 / MAX(self.traitCollection.displayScale, 1.0);
    CGFloat rowHeight = ceil([[UIFontMetrics metricsForTextStyle:UIFontTextStyleSubheadline] scaledValueForValue:25]);
    CGFloat headingHeight = ceil([[UIFontMetrics metricsForTextStyle:UIFontTextStyleCaption1] scaledValueForValue:18]);
    _gameOverview.frame = CGRectMake(0, 0, width, [GameOverviewView height]);
    _periodScoresHeader.frame = CGRectMake(0, CGRectGetMaxY(_gameOverview.frame), width, headingHeight);
    _topPeriodScores.frame = CGRectMake(0, CGRectGetMaxY(_periodScoresHeader.frame), width, rowHeight);
    _bottomPeriodScores.frame = CGRectMake(0, CGRectGetMaxY(_topPeriodScores.frame) + pixel, width, rowHeight);
    CGFloat controlY = CGRectGetMaxY(_bottomPeriodScores.frame);
    _segmentBackground.frame = CGRectMake(0, controlY, width, CGRectGetHeight(self.contentView.bounds) - controlY);
    _sectionControl.frame = CGRectMake(12, controlY + 6, MAX(0, width - 24),
                                     CGRectGetHeight(self.contentView.bounds) - controlY - 12);
}

+ (CGFloat)height {
    CGFloat rowHeight = ceil([[UIFontMetrics metricsForTextStyle:UIFontTextStyleSubheadline] scaledValueForValue:25]);
    CGFloat headingHeight = ceil([[UIFontMetrics metricsForTextStyle:UIFontTextStyleCaption1] scaledValueForValue:18]);
    CGFloat controlHeight = MAX(44, ceil([[UIFontMetrics metricsForTextStyle:UIFontTextStyleBody] scaledValueForValue:36]));
    // Round up the fractional pixel separator without shrinking the control's hit target.
    return ceil([GameOverviewView height] + headingHeight + 2 * rowHeight + controlHeight + 13);
}

- (void)setGame:(GameModel *)game {
    [_gameOverview setGame:game.gameObject];
    [_topPeriodScores setScores:game ForTeam:game.homeTeam];
    [_bottomPeriodScores setScores:game ForTeam:game.awayTeam];
    [_periodScoresHeader setGame:game];
    [self setNeedsLayout];
}
@end
