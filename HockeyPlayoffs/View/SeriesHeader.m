#import "SeriesHeader.h"
#import "ScoreGridLayout.h"
#import "SeriesModel.h"
#import "TeamHandler.h"
#import "SeriesHeaderScoresView.h"
#import "Colors.h"

@interface SeriesHeader ()
@property UIView *topLeadingBackground;
@property UIView *bottomLeadingBackground;
@property UILabel *topTeamLabel;
@property UILabel *bottomTeamLabel;
@property SeriesHeaderScoresView *topScoresView;
@property SeriesHeaderScoresView *bottomScoresView;
@end

@implementation SeriesHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    self.contentView.backgroundColor = [Colors seriesHeaderBackgroundColor];
    self.contentView.layer.cornerRadius = 24;
    self.contentView.layer.cornerCurve = kCACornerCurveContinuous;
    self.contentView.clipsToBounds = YES;
    _topLeadingBackground = [[UIView alloc] init];
    _bottomLeadingBackground = [[UIView alloc] init];
    _topTeamLabel = [self teamLabel];
    _bottomTeamLabel = [self teamLabel];
    _topScoresView = [[SeriesHeaderScoresView alloc] init];
    _bottomScoresView = [[SeriesHeaderScoresView alloc] init];
    _topScoresView.trailingContentInset = 16;
    _bottomScoresView.trailingContentInset = 16;
    for (UIView *view in @[_topLeadingBackground, _bottomLeadingBackground, _topTeamLabel, _bottomTeamLabel, _topScoresView, _bottomScoresView]) {
        [self.contentView addSubview:view];
    }
    return self;
}

- (UILabel *)teamLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.adjustsFontForContentSizeCategory = YES;
    label.textColor = [Colors seriesTeamNameColor];
    label.backgroundColor = [Colors seriesTeamNameBackgroundColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 1;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.6;
    return label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat scale = MAX(self.traitCollection.displayScale, 1.0);
    CGFloat pixel = 1.0 / scale;
    CGFloat leadingInset = 16;
    CGFloat trailingInset = _topScoresView.trailingContentInset;
    CGFloat width = MAX(0, CGRectGetWidth(self.contentView.bounds) - leadingInset - trailingInset);
    CGFloat rowHeight = floor((CGRectGetHeight(self.contentView.bounds) * scale - 1) / 2) / scale;
    // Four extra points on each side of a score, without widening the gaps.
    ScoreGridLayout layout = ScoreGridLayoutMake(width, 7, 44, 104, self.traitCollection);
    CGFloat teamWidth = layout.teamWidth;
    CGFloat scoresX = leadingInset + teamWidth + pixel;
    _topLeadingBackground.frame = CGRectMake(0, 0, leadingInset, rowHeight);
    _bottomLeadingBackground.frame = CGRectMake(0, rowHeight + pixel, leadingInset, CGRectGetHeight(self.contentView.bounds) - rowHeight - pixel);
    _topTeamLabel.frame = CGRectMake(leadingInset, 0, teamWidth, rowHeight);
    _topScoresView.frame = CGRectMake(scoresX, 0, MAX(0, CGRectGetWidth(self.contentView.bounds) - scoresX), rowHeight);
    _bottomTeamLabel.frame = CGRectMake(leadingInset, rowHeight + pixel, teamWidth, CGRectGetHeight(self.contentView.bounds) - rowHeight - pixel);
    _bottomScoresView.frame = CGRectMake(scoresX, rowHeight + pixel, MAX(0, CGRectGetWidth(self.contentView.bounds) - scoresX), CGRectGetHeight(_bottomTeamLabel.frame));
}

- (void)setSeries:(SeriesModel *)series {
    _topTeamLabel.text = [self titleForTeam:series.topTeam wins:series.topWins];
    _bottomTeamLabel.text = [self titleForTeam:series.bottomTeam wins:series.bottomWins];
    _topTeamLabel.backgroundColor = [TeamHandler getTeamColor:series.topTeam];
    _bottomTeamLabel.backgroundColor = [TeamHandler getTeamColor:series.bottomTeam];
    _topLeadingBackground.backgroundColor = _topTeamLabel.backgroundColor;
    _bottomLeadingBackground.backgroundColor = _bottomTeamLabel.backgroundColor;
    [_topScoresView setScores:series.getGames ForTeam:series.topTeam];
    [_bottomScoresView setScores:series.getGames ForTeam:series.bottomTeam];
    [self setNeedsLayout];
}

- (NSString *)titleForTeam:(NSString *)team wins:(NSUInteger)wins {
    if (team.length == 0) return @"";
    return [NSString stringWithFormat:@"%@ – %lu", team.uppercaseString, (unsigned long)wins];
}

+ (CGFloat)height {
    return 2 * ceil([[UIFontMetrics metricsForTextStyle:UIFontTextStyleSubheadline] scaledValueForValue:28]) + 1;
}
@end
