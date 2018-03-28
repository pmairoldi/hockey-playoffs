//
//  SeriesCell.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2/26/2014.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "SeriesCell.h"
#import "TeamHandler.h"
#import "Colors.h"
#import "SeriesObject.h"
#import "Dimensions.h"

@interface SeriesCell ()

@property UILabel *topTeamLabel;
@property UILabel *bottomTeamLabel;

@property UILabel *topTeamWinsLabel;
@property UILabel *bottomTeamWinsLabel;

@property UIActivityIndicatorView *activityIndicator;

@property BOOL hasGameToday;

@end

@implementation SeriesCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _topTeamLabel = [[UILabel alloc] init];
        [self setTeamLabelProperties:_topTeamLabel];
        
        _topTeamWinsLabel = [[UILabel alloc] init];
        [self setWinLabelProperties:_topTeamWinsLabel];

        _bottomTeamLabel = [[UILabel alloc] init];
        [self setTeamLabelProperties:_bottomTeamLabel];

        _bottomTeamWinsLabel = [[UILabel alloc] init];
        [self setWinLabelProperties:_bottomTeamWinsLabel];
    
        [self.contentView addSubview:_topTeamLabel];
        [self.contentView addSubview:_topTeamWinsLabel];
        
        [self.contentView addSubview:_bottomTeamLabel];
        [self.contentView addSubview:_bottomTeamWinsLabel];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] init];
        _activityIndicator.hidesWhenStopped = YES;
        
        [self.contentView addSubview:_activityIndicator];
    }
    
    return self;
}
-(void)setRefresh:(BOOL)refresh {
    
    if (refresh) {
        [_activityIndicator startAnimating];
    }
    
    else {
        [_activityIndicator stopAnimating];
    }
}

-(void)setSeries:(SeriesObject *)series {

//    if (series.seasonID.length != 0 || series.topTeam.length != 0 || series.bottomTeam.length != 0) {
//        [_activityIndicator stopAnimating];
//    }
    
    _topTeamLabel.text = [series.topTeam uppercaseString];
    _bottomTeamLabel.text = [series.bottomTeam uppercaseString];
    
    if (series.topTeam.length == 0 || series.bottomTeam.length == 0) {
        
        _topTeamWinsLabel.text = @"";
        _bottomTeamWinsLabel.text = @"";
    }
    
    else {
        _topTeamWinsLabel.text = [NSString stringWithFormat:@"%ld", (long)series.topWins];
        _bottomTeamWinsLabel.text = [NSString stringWithFormat:@"%ld", (long)series.bottomWins];
    }
    
    [self setAccessibilityIdentifier:[NSString stringWithFormat:@"Series-%@", [series getRelativeSeriesID]]];
    
    [self layoutSubviews];
}

-(void)setTeamLabelProperties:(UILabel *)label {
    
    label.textColor = [Colors seriesTeamNameColor];
    label.font = [UIFont boldSystemFontOfSize:SERIES_NAME_FONT_SIZE];
    label.textAlignment = NSTextAlignmentLeft;
}

-(void)setWinLabelProperties:(UILabel *)label {
    
    label.textColor = [Colors seriesTeamNameColor];
    label.font = [UIFont systemFontOfSize:SERIES_WINS_FONT_SIZE];
    label.textAlignment = NSTextAlignmentRight;
}

-(void)setTodayIndicator:(BOOL)hasGameToday {
    
    _hasGameToday = hasGameToday;
    
    [self setNeedsDisplay];
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_topTeamWinsLabel sizeToFit];
    [_bottomTeamWinsLabel sizeToFit];
    
    CGRect insetRect = CGRectInset(self.contentView.frame, SERIES_STROKE_SIZE, SERIES_STROKE_SIZE);
    
    CGRect sliceRect;
    CGRect remainderRect;
    
    CGRectDivide(insetRect, &sliceRect, &remainderRect, insetRect.size.height/2, CGRectMinYEdge);
    
    int margin = 4;
    
    _topTeamLabel.frame = CGRectMake(sliceRect.origin.x + margin, sliceRect.origin.y, sliceRect.size.width - _topTeamWinsLabel.frame.size.width - 2*margin, sliceRect.size.height);
    _topTeamWinsLabel.frame = CGRectMake(sliceRect.origin.x + sliceRect.size.width - _topTeamWinsLabel.frame.size.width - margin, sliceRect.origin.y, _topTeamWinsLabel.frame.size.width, sliceRect.size.height);

    _bottomTeamLabel.frame = CGRectMake(remainderRect.origin.x + margin, remainderRect.origin.y, remainderRect.size.width - _bottomTeamWinsLabel.frame.size.width - 2*margin, remainderRect.size.height);
    _bottomTeamWinsLabel.frame = CGRectMake(remainderRect.origin.x + remainderRect.size.width - _bottomTeamWinsLabel.frame.size.width - margin, remainderRect.origin.y, _bottomTeamWinsLabel.frame.size.width, remainderRect.size.height);

    _activityIndicator.center = CGPointMake(CGRectGetWidth(self.contentView.frame)/2, CGRectGetHeight(self.contentView.frame)/2);
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code

    UIRectCorner cornersToRound = UIRectCornerAllCorners; //UIRectCornerBottomLeft | UIRectCornerTopRight
    CGFloat strokeWidth = SERIES_STROKE_SIZE;
    CGSize cornerRadius = CGSizeMake(CORNER_RADIUS - strokeWidth, CORNER_RADIUS - strokeWidth);
    CGSize outerCornerRadius = CGSizeMake(CORNER_RADIUS, CORNER_RADIUS);

    CGRect insetRect = CGRectInset(rect, strokeWidth, strokeWidth);
    
    CGRect sliceRect;
    CGRect remainderRect;

    CGRectDivide(insetRect, &sliceRect, &remainderRect, insetRect.size.height/2, CGRectMinYEdge);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    //draw border
    CGContextSaveGState(context);

    if (_hasGameToday) {
        CGContextSetFillColorWithColor(context, [[Colors seriesBorderTodayColor] CGColor]);
    }
    
    else {
        CGContextSetFillColorWithColor(context, [[Colors seriesBorderColor] CGColor]);
    }
    
    [[UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:cornersToRound cornerRadii:outerCornerRadius] fill];

    CGContextRestoreGState(context);
    
    //draw fill inside border
    CGContextSaveGState(context);
    
    if (_hasGameToday) {
        CGContextSetFillColorWithColor(context, [[Colors seriesBorderTodayColor] CGColor]);
    }
    
    else {
        CGContextSetFillColorWithColor(context, [[Colors seriesBackgroundColor] CGColor]);
    }
    
    [[UIBezierPath bezierPathWithRoundedRect:insetRect byRoundingCorners:cornersToRound cornerRadii:cornerRadius] fill];
    
    CGContextRestoreGState(context);
    
    //draw top team background
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, [[TeamHandler getTeamColor:_topTeamLabel.text] CGColor]);
    
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(sliceRect.origin.x, sliceRect.origin.y, sliceRect.size.width, sliceRect.size.height - 0.5) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:cornerRadius] fill];
    
    CGContextRestoreGState(context);
    
    //draw bottom team background
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, [[TeamHandler getTeamColor:_bottomTeamLabel.text] CGColor]);
    
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(remainderRect.origin.x, remainderRect.origin.y + 0.5, remainderRect.size.width, remainderRect.size.height -0.5) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:cornerRadius] fill];
    
    CGContextRestoreGState(context);
    
    //draw overlay
    
    if (self.selected || self.highlighted) {
     
        CGContextSaveGState(context);
        
        CGContextSetFillColorWithColor(context, [[Colors seriesSelectedColor] CGColor]);
        
        [[UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:cornersToRound cornerRadii:outerCornerRadius] fill];
        
        CGContextRestoreGState(context);
    }
}

@end
