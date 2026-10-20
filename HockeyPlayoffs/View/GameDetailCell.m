#import "GameDetailCell.h"
#import "TeamImage.h"
#import "EventObject.h"
#import "Colors.h"

@interface GameDetailCell ()
@property TeamImage *teamImage;
@property UILabel *timeLabel;
@property UILabel *eventLabel;
@property NSLayoutConstraint *identityWidth;
@end

@implementation GameDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    self.backgroundColor = [Colors gameBackgroundColor];
    self.contentView.backgroundColor = [Colors gameBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _teamImage = [[TeamImage alloc] init];
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    _timeLabel.adjustsFontForContentSizeCategory = YES;
    _timeLabel.textColor = [Colors gameDetailCellTimeColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _eventLabel = [[UILabel alloc] init];
    _eventLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _eventLabel.adjustsFontForContentSizeCategory = YES;
    _eventLabel.textColor = [Colors gameDetailCellTextColor];
    _eventLabel.numberOfLines = 0;
    UIStackView *identity = [[UIStackView alloc] initWithArrangedSubviews:@[_teamImage, _timeLabel]];
    identity.axis = UILayoutConstraintAxisVertical;
    identity.alignment = UIStackViewAlignmentCenter;
    identity.spacing = 4;
    UIStackView *row = [[UIStackView alloc] initWithArrangedSubviews:@[identity, _eventLabel]];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.alignment = UIStackViewAlignmentCenter;
    row.spacing = 16;
    row.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:row];
    _identityWidth = [identity.widthAnchor constraintEqualToConstant:44];
    [self updateIdentityWidth];
    [self registerForTraitChanges:@[[UITraitPreferredContentSizeCategory class]]
                     withHandler:^(__kindof GameDetailCell *cell, UITraitCollection *previousTraits) {
        [cell updateIdentityWidth];
    }];
    [NSLayoutConstraint activateConstraints:@[
        [_teamImage.widthAnchor constraintEqualToConstant:32],
        [_teamImage.heightAnchor constraintEqualToConstant:32],
        _identityWidth,
        [row.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12],
        [row.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-12],
        [row.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor],
        [row.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor]
    ]];
    [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    return self;
}

- (void)updateIdentityWidth {
    _identityWidth.constant = ceil([[UIFontMetrics metricsForTextStyle:UIFontTextStyleCaption1]
                                   scaledValueForValue:44 compatibleWithTraitCollection:self.traitCollection]);
}

+ (CGFloat)height { return 80; }

- (void)setEvent:(EventObject *)event {
    _timeLabel.text = event.time;
    _eventLabel.text = event.details;
    [_teamImage setSmallImage:event.teamID];
}
@end
