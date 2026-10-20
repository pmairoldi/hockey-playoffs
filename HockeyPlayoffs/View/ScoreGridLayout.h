#pragma once
#import <UIKit/UIKit.h>

// Numeric columns keep their preferred width; the team column takes the rest.
// Only compress numbers when a narrow container cannot fit the team minimum.
typedef struct {
    CGFloat teamWidth;
    CGFloat scoreWidth;
    CGFloat gap;
} ScoreGridLayout;

NS_INLINE ScoreGridLayout ScoreGridLayoutMake(CGFloat width, NSUInteger scoreColumns,
                                              CGFloat preferredScoreWidth, CGFloat minimumTeamWidth,
                                              UITraitCollection *traits) {
    CGFloat scale = MAX(traits.displayScale, 1.0);
    UIFontMetrics *metrics = [UIFontMetrics metricsForTextStyle:UIFontTextStyleSubheadline];
    CGFloat usablePixels = MAX(0, round(width * scale) - scoreColumns);
    // At accessibility sizes, do not let the team minimum starve the numbers.
    CGFloat teamPixels = MIN(floor(usablePixels * 0.42), ceil([metrics scaledValueForValue:minimumTeamWidth
                                             compatibleWithTraitCollection:traits] * scale));
    CGFloat scorePixels = MIN(round([metrics scaledValueForValue:preferredScoreWidth
                                      compatibleWithTraitCollection:traits] * scale),
                              floor((usablePixels - teamPixels) / MAX(scoreColumns, 1)));
    return (ScoreGridLayout){(usablePixels - scoreColumns * scorePixels) / scale,
                              scorePixels / scale, 1.0 / scale};
}

NS_INLINE CGRect ScoreGridNumericFrame(ScoreGridLayout layout, NSUInteger index, CGFloat height) {
    return CGRectMake(layout.teamWidth + layout.gap + index * (layout.scoreWidth + layout.gap),
                      0, layout.scoreWidth, height);
}
