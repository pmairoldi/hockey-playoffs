// Original TV-style highlights control, with the existing enabled/disabled palette.
#import "VideoButton.h"
#import "Colors.h"
#import "Dimensions.h"

@implementation VideoButton

@synthesize tintColor = _tintColor;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = UIColor.clearColor;
    self.tintColor = [Colors videoButtonDisabledColor];
    self.contentMode = UIViewContentModeRedraw;
    [self registerForTraitChanges:@[[UITraitUserInterfaceStyle class]]
                     withHandler:^(__kindof VideoButton *button, UITraitCollection *previousTraits) {
        [button setNeedsDisplay];
    }];
    return self;
}

- (void)updateTint {
    self.tintColor = self.enabled ? [Colors videoButtonEnabledColor] : [Colors videoButtonDisabledColor];
    [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateTint];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateTint];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateTint];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self setNeedsDisplay];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Retain the original 30-point icon inside the larger accessible hit target.
    CGRect icon = CGRectMake((CGRectGetWidth(self.bounds) - VIDEO_BUTTON_WIDTH) / 2,
                             (CGRectGetHeight(self.bounds) - VIDEO_BUTTON_HEIGHT) / 2,
                             VIDEO_BUTTON_WIDTH, VIDEO_BUTTON_HEIGHT);
    CGRect screenRect, lineRect;
    CGRectDivide(icon, &lineRect, &screenRect, icon.size.height * 0.3, CGRectMaxYEdge);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, screenRect);
    CGContextAddRect(context, CGRectInset(screenRect, VIDEO_LINE_HEIGHT, VIDEO_LINE_HEIGHT));
    CGRect lineInset = CGRectInset(lineRect, icon.size.width * 0.2, 0);
    CGContextAddRect(context, CGRectMake(CGRectGetMinX(lineInset), CGRectGetMidY(lineInset) - VIDEO_LINE_HEIGHT / 2,
                                        CGRectGetWidth(lineInset), VIDEO_LINE_HEIGHT));
    CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
    CGContextEOFillPath(context);
}
@end
