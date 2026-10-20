// Shared compact scoreboard used by game rows and the game summary.
#import "GameOverviewView.h"
#import "TeamImage.h"
#import "VideoButton.h"
#import "GameObject.h"
#import "TeamHandler.h"
#import "Colors.h"

@interface GameOverviewView ()
@property UILabel *leftTeamLabel;
@property UILabel *rightTeamLabel;
@property TeamImage *leftTeamImage;
@property TeamImage *rightTeamImage;
@property UILabel *gameStatusLabel;
@property UILabel *leftScoreLabel;
@property UILabel *rightScoreLabel;
@property UILabel *leftStatusIndicatorLabel;
@property UILabel *rightStatusIndicatorLabel;
@end

@implementation GameOverviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = UIColor.clearColor;
    _leftTeamImage = [[TeamImage alloc] init];
    _rightTeamImage = [[TeamImage alloc] init];
    _leftTeamLabel = [self labelWithStyle:UIFontTextStyleSubheadline color:[Colors gameCellTeamTextColor]];
    _rightTeamLabel = [self labelWithStyle:UIFontTextStyleSubheadline color:[Colors gameCellTeamTextColor]];
    UIFont *teamFont = [[UIFontMetrics metricsForTextStyle:UIFontTextStyleSubheadline]
                        scaledFontForFont:[UIFont systemFontOfSize:14]];
    _leftTeamLabel.font = teamFont;
    _rightTeamLabel.font = teamFont;
    _leftScoreLabel = [self labelWithStyle:UIFontTextStyleLargeTitle color:[Colors gameCellScoreColor]];
    _rightScoreLabel = [self labelWithStyle:UIFontTextStyleLargeTitle color:[Colors gameCellScoreColor]];
    UIFont *scoreFont = [self.class scoreFont];
    _leftScoreLabel.font = scoreFont;
    _rightScoreLabel.font = scoreFont;
    _gameStatusLabel = [self labelWithStyle:UIFontTextStyleCaption1 color:[Colors gameCellStatusTextColor]];
    _leftStatusIndicatorLabel = [self labelWithStyle:UIFontTextStyleCaption2 color:[Colors gameLabelTextColor]];
    _rightStatusIndicatorLabel = [self labelWithStyle:UIFontTextStyleCaption2 color:[Colors gameLabelTextColor]];
    _leftStatusIndicatorLabel.numberOfLines = 0;
    _rightStatusIndicatorLabel.numberOfLines = 0;
    _videoButton = [[VideoButton alloc] init];
    _videoButton.accessibilityIdentifier = @"Play Highlights";
    _videoButton.accessibilityLabel = NSLocalizedString(@"Highlights", nil);
    for (UIView *view in @[_leftTeamImage, _rightTeamImage, _leftTeamLabel, _rightTeamLabel,
                          _leftScoreLabel, _rightScoreLabel, _gameStatusLabel,
                          _leftStatusIndicatorLabel, _rightStatusIndicatorLabel, _videoButton]) {
        [self addSubview:view];
    }
    [self registerForTraitChanges:@[[UITraitPreferredContentSizeCategory class]]
                     withHandler:^(__kindof GameOverviewView *view, UITraitCollection *previousTraits) {
        view.leftScoreLabel.font = [view.class scoreFont];
        view.rightScoreLabel.font = [view.class scoreFont];
        [view setNeedsLayout];
    }];
    return self;
}

+ (UIFont *)scoreFont {
    return [[UIFontMetrics metricsForTextStyle:UIFontTextStyleLargeTitle]
            scaledFontForFont:[UIFont monospacedDigitSystemFontOfSize:35 weight:UIFontWeightSemibold]];
}

- (UILabel *)labelWithStyle:(UIFontTextStyle)style color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont preferredFontForTextStyle:style];
    label.adjustsFontForContentSizeCategory = YES;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.65;
    return label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    BOOL accessible = UIContentSizeCategoryIsAccessibilityCategory(self.traitCollection.preferredContentSizeCategory);
    _leftTeamLabel.numberOfLines = accessible ? 0 : 2;
    _rightTeamLabel.numberOfLines = accessible ? 0 : 2;
    if (accessible) {
        // Keep each team's name and score together when large text needs rows.
        CGFloat nameWidth = MAX(0, width - 90);
        CGFloat y = 12;
        for (NSArray *team in @[@[_leftTeamImage, _leftTeamLabel, _leftScoreLabel, _leftStatusIndicatorLabel],
                               @[_rightTeamImage, _rightTeamLabel, _rightScoreLabel, _rightStatusIndicatorLabel]]) {
            TeamImage *image = team[0];
            UILabel *name = team[1], *score = team[2], *indicator = team[3];
            CGFloat nameHeight = MAX(50, [name sizeThatFits:CGSizeMake(nameWidth, CGFLOAT_MAX)].height);
            image.frame = CGRectMake(16, y + (nameHeight - 50) / 2, 50, 50);
            name.frame = CGRectMake(74, y, nameWidth, nameHeight);
            name.textAlignment = NSTextAlignmentLeft;
            y += nameHeight + 4;
            CGFloat scoreHeight = score.font.lineHeight;
            score.frame = CGRectMake(16, y, MAX(0, width / 2 - 20), scoreHeight);
            indicator.frame = CGRectMake(width / 2, y, MAX(0, width / 2 - 16), scoreHeight);
            y += scoreHeight + 8;
            if (image == _leftTeamImage) {
                CGFloat statusHeight = _gameStatusLabel.font.lineHeight * 2;
                _gameStatusLabel.frame = CGRectMake(16, y, MAX(0, width - 32), statusHeight);
                y += statusHeight + 8;
            }
        }
        _videoButton.frame = CGRectMake((width - 44) / 2, MAX(y, height - 52), 44, 44);
        return;
    }

    // Original two-tier arrangement: badges and scores above names and TV control.
    CGFloat imageSize = 50;
    CGFloat inset = 16;
    CGFloat top = 12;
    CGFloat sideWidth = MAX(0, (width - 2 * inset - 72) / 2);
    CGFloat scoreWidth = MIN(40, MAX(24, sideWidth - imageSize - 30));
    _leftTeamImage.frame = CGRectMake(inset, top, imageSize, imageSize);
    _rightTeamImage.frame = CGRectMake(width - inset - imageSize, top, imageSize, imageSize);
    _leftScoreLabel.frame = CGRectMake(CGRectGetMaxX(_leftTeamImage.frame) + 4, top, scoreWidth, imageSize);
    _rightScoreLabel.frame = CGRectMake(CGRectGetMinX(_rightTeamImage.frame) - 4 - scoreWidth, top, scoreWidth, imageSize);
    CGFloat indicatorWidth = MAX(0, sideWidth - imageSize - scoreWidth - 8);
    _leftStatusIndicatorLabel.frame = CGRectMake(CGRectGetMaxX(_leftScoreLabel.frame) + 4, top, indicatorWidth, imageSize);
    _rightStatusIndicatorLabel.frame = CGRectMake(CGRectGetMinX(_rightScoreLabel.frame) - 4 - indicatorWidth, top, indicatorWidth, imageSize);
    CGFloat statusX = CGRectGetMaxX(_leftStatusIndicatorLabel.frame) + 4;
    _gameStatusLabel.frame = CGRectMake(statusX, top, MAX(0, width - 2 * statusX), imageSize);
    CGFloat nameY = CGRectGetMaxY(_leftTeamImage.frame) + 4;
    CGFloat nameWidth = MAX(0, (width - 44 - 2 * inset - 16) / 2);
    CGFloat nameHeight = MAX(0, height - nameY - 8);
    _leftTeamLabel.frame = CGRectMake(inset, nameY, nameWidth, nameHeight);
    _rightTeamLabel.frame = CGRectMake(width - inset - nameWidth, nameY, nameWidth, nameHeight);
    _leftTeamLabel.textAlignment = NSTextAlignmentLeft;
    _rightTeamLabel.textAlignment = NSTextAlignmentRight;
    // Keep the expanded TV hit target below the row's center tap/navigation area.
    _videoButton.frame = CGRectMake((width - 44) / 2, height - 52, 44, 44);
}

+ (CGFloat)height {
    if (!UIContentSizeCategoryIsAccessibilityCategory(UIApplication.sharedApplication.preferredContentSizeCategory)) {
        return ceil([[UIFontMetrics metricsForTextStyle:UIFontTextStyleBody] scaledValueForValue:112]);
    }
    CGFloat names = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline].lineHeight * 4;
    CGFloat status = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1].lineHeight * 2;
    return ceil(2 * (MAX(50, names) + [self scoreFont].lineHeight + 12) + status + 68);
}

- (void)setGame:(GameObject *)game {
    [self setTeam:game.awayID image:_leftTeamImage label:_leftTeamLabel];
    [self setTeam:game.homeID image:_rightTeamImage label:_rightTeamLabel];
    _gameStatusLabel.text = [game getGameStatus];
    _leftScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[game getScoreForTeam:game.awayID]];
    _rightScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[game getScoreForTeam:game.homeID]];
    _leftStatusIndicatorLabel.attributedText = [self statusText:game.awayStatus];
    _rightStatusIndicatorLabel.attributedText = [self statusText:game.homeStatus];
    _leftStatusIndicatorLabel.hidden = game.awayStatus.length == 0;
    _rightStatusIndicatorLabel.hidden = game.homeStatus.length == 0;
    _videoButton.enabled = [game hasVideo];
    [self setNeedsLayout];
}

- (NSAttributedString *)statusText:(NSString *)statuses {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    for (NSString *status in [statuses.uppercaseString componentsSeparatedByString:@","]) {
        NSString *value = [status stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        UIColor *color = [value isEqualToString:@"PP"] ? [Colors powerplayColor] :
                         [value isEqualToString:@"EN"] ? [Colors emptyNetColor] : [Colors gameLabelTextColor];
        if (text.length) [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:value attributes:@{NSForegroundColorAttributeName:color}]];
    }
    return text;
}

- (void)setTeam:(NSString *)team image:(TeamImage *)image label:(UILabel *)label {
    label.text = [NSString stringWithFormat:@"%@\n%@", [TeamHandler getTeamCity:team], [TeamHandler getTeamName:team]];
    [image setLargeImage:team];
}
@end
