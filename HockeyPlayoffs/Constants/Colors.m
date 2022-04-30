//
//  Colours.m
//  HockeyPlayoffs
//
//  Created by Pierre-Marc Airoldi on 2015-06-23.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "Colors.h"

@implementation Colors

+(UIColor *)tintColor {
    return [UIColor colorNamed:@"tintColor"];
 }

+(UIColor *)darkGrayColor {
    return [UIColor colorNamed:@"darkGrayColor"];
}

+(UIColor *)lightGrayColor {
    return [UIColor colorNamed:@"lightGrayColor"];
}

+(UIColor *)lightColor {
    return [UIColor whiteColor];
}

+(UIColor *)ultraLightGrayColor {
    return [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
}

+(UIColor *)backgroundColor {
    return [[self class] darkGrayColor];
}

+(UIColor *)seriesBackgroundColor {
    return [[self class] lightColor];
}

+(UIColor *)seriesBorderColor {
    return [[self class] lightColor];
}

+(UIColor *)seriesBorderTodayColor {
    return [[self class] tintColor];
}

+(UIColor *)seriesSelectedColor {
    return [UIColor colorWithWhite:0.7 alpha:0.7];
}

+(UIColor *)bracketLineColor {
    return [[self class] lightColor];
}

+(UIColor *)seriesTeamNameColor {
    return [[self class] lightColor];
}

+(UIColor *)seriesTeamWinsColor {
    return [[self class] lightColor];
}

+(UIColor *)seriesHeaderBackgroundColor {
    return [[self class] lightColor];
}

+(UIColor *)gameBackgroundColor {
    return [[self class] lightColor];
}

+(UIColor *)gameCellStatusTextColor {
    return [[self class] darkGrayColor];
}

+(UIColor *)gameCellTeamTextColor {
    return [[self class] lightGrayColor];
}

+(UIColor *)tableViewSeperatorColor {
    return [[self class] ultraLightGrayColor];
}

+(UIColor *)navigationBarColor {
    return [UIColor colorNamed:@"navigationBarColor"];
}

+(UIColor *)navigationBarBorderColor {
    return [UIColor colorNamed:@"navigationBarBorderColor"];
}

+(UIColor *)gameDetailCellTextColor {
    return [[self class] darkGrayColor];
}

+(UIColor *)gameDetailCellTimeColor {
    return [[self class] lightGrayColor];
}

+(UIColor *)gameDetailHeaderTextColor {
    return [[self class] darkGrayColor];
}

+(UIColor *)gameDetailHeaderBackgroundColor {
    return [[self class] ultraLightGrayColor];
}

+(UIColor *)gameCellScoreColor {
    return [[self class] darkGrayColor];
}

+(UIColor *)periodScoreBackgroundColor {
    return [[self class] darkGrayColor];
}

+(UIColor *)periodScoreSeperatorColor {
    return [[self class] lightColor];
}

+(UIColor *)segmentBackgroundColor {
    return [UIColor clearColor];
}

+(UIColor *)segmentTintColor {
    return [[self class] tintColor];
}

+(UIColor *)periodScoreViewHeaderFontColor {
    return [[self class] lightGrayColor];
}

+(UIColor *)videoButtonDisabledColor {
    return [[self class] ultraLightGrayColor];
}

+(UIColor *)videoButtonUnselectedColor {
    return [[self class] tintColor];
}

+(UIColor *)videoButtonSelectedColor {
    return [[self class] lightGrayColor];
}

+(UIColor *)seriesCellBackgroundColor {
    return [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
}

+(UIColor *)expandedVideoBackgroundColor {
    return [[self class] lightColor];
}

+(UIColor *)gameLabelTextColor {
    return [[self class] lightGrayColor];
}

+(UIColor *)powerplayColor {
    return [UIColor colorWithRed:245.0/255.0 green:32.0/255.0 blue:50.0/255.0 alpha:1.0];
}

+(UIColor *)emptyNetColor {
    return [UIColor colorWithRed:248.0/255.0 green:179.0/255.0 blue:65.0/255.0 alpha:1.0];
}

@end
