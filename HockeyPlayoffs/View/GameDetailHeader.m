#import "GameDetailHeader.h"
#import "Colors.h"

@implementation GameDetailHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    UIListContentConfiguration *configuration = [self defaultContentConfiguration];
    configuration.textProperties.color = [Colors gameDetailHeaderTextColor];
    self.contentConfiguration = configuration;
    UIBackgroundConfiguration *background = [UIBackgroundConfiguration clearConfiguration];
    self.backgroundConfiguration = background;
    return self;
}

+ (CGFloat)height {
    return ceil([[UIFontMetrics metricsForTextStyle:UIFontTextStyleHeadline] scaledValueForValue:36]);
}

- (void)setPeriod:(NSString *)period {
    UIListContentConfiguration *configuration = [self defaultContentConfiguration];
    configuration.text = period;
    configuration.textProperties.color = [Colors gameDetailHeaderTextColor];
    self.contentConfiguration = configuration;
}
@end
