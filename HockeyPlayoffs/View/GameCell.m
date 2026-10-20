#import "GameCell.h"
#import "GameObject.h"
#import "VideoButton.h"
#import "Colors.h"

@interface GameCell ()
@property GameOverviewView *gameOverview;
@property UIView *rowSeparator;
@end

@implementation GameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _gameOverview = [[GameOverviewView alloc] initWithFrame:CGRectZero];
    _videoButton = _gameOverview.videoButton;
    _gameOverview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_gameOverview];
    _rowSeparator = [[UIView alloc] init];
    _rowSeparator.backgroundColor = [Colors gameSeperatorColor];
    _rowSeparator.hidden = YES;
    _rowSeparator.userInteractionEnabled = NO;
    [self.contentView addSubview:_rowSeparator];
    [NSLayoutConstraint activateConstraints:@[
        [_gameOverview.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [_gameOverview.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        [_gameOverview.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [_gameOverview.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor]
    ]];
    return self;
}

- (void)setShowsBottomSeparator:(BOOL)showsBottomSeparator {
    _showsBottomSeparator = showsBottomSeparator;
    _rowSeparator.hidden = !showsBottomSeparator;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat pixel = 1.0 / MAX(self.traitCollection.displayScale, 1.0);
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    // Custom overview cells have zero content margins; match Series' 20-point dividers.
    CGFloat inset = MIN(20, width / 2);
    _rowSeparator.frame = CGRectMake(inset, CGRectGetHeight(self.contentView.bounds) - pixel,
                                     MAX(0, width - 2 * inset), pixel);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) self.accessibilityTraits |= UIAccessibilityTraitSelected;
    else self.accessibilityTraits &= ~UIAccessibilityTraitSelected;
}

- (void)updateConfigurationUsingState:(UICellConfigurationState *)state {
    // Let UIKit round the section, rather than covering its corners with an opaque overview.
    UIBackgroundConfiguration *background = [UIBackgroundConfiguration listGroupedCellConfiguration];
    background.backgroundColor = state.isSelected || state.isHighlighted ?
        [Colors gameBackgroundSelectedColor] : [Colors gameBackgroundColor];
    self.backgroundConfiguration = background;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
}

+ (CGFloat)height {
    return [GameOverviewView height];
}

- (void)setGame:(GameObject *)game {
    [_gameOverview setGame:game];
    self.accessibilityIdentifier = [NSString stringWithFormat:@"Game-%@", [game getRelativeGameID]];
}
@end
