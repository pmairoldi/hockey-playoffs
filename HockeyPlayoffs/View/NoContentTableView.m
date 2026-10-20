#import "NoContentTableView.h"
#import "Colors.h"

@interface NoContentTableView ()
@property UILabel *noContentLabel;
@end

@implementation NoContentTableView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame style:UITableViewStyleInsetGrouped];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (!self) return nil;
    UIView *emptyView = [[UIView alloc] init];
    _noContentLabel = [[UILabel alloc] init];
    _noContentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _noContentLabel.adjustsFontForContentSizeCategory = YES;
    _noContentLabel.textColor = [Colors noDataTextColor];
    _noContentLabel.numberOfLines = 0;
    _noContentLabel.textAlignment = NSTextAlignmentCenter;
    _noContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [emptyView addSubview:_noContentLabel];
    [NSLayoutConstraint activateConstraints:@[
        [_noContentLabel.centerYAnchor constraintEqualToAnchor:emptyView.centerYAnchor],
        [_noContentLabel.leadingAnchor constraintEqualToAnchor:emptyView.layoutMarginsGuide.leadingAnchor],
        [_noContentLabel.trailingAnchor constraintEqualToAnchor:emptyView.layoutMarginsGuide.trailingAnchor]
    ]];
    self.backgroundView = emptyView;
    self.hasContent = NO;
    return self;
}

- (void)setNoContentText:(NSString *)noContentText {
    _noContentText = noContentText;
    _noContentLabel.text = noContentText;
}

- (void)setHasContent:(BOOL)hasContent {
    _hasContent = hasContent;
    self.backgroundView.hidden = hasContent;
}
@end
