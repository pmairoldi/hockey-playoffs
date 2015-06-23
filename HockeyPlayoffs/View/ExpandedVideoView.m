//
//  ExpandedVideoView.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-28.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "ExpandedVideoView.h"
#import "Colours.h"
#import "TeamHandler.h"

@interface ExpandedVideoView ()

@end

@implementation ExpandedVideoView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = EXPANDED_VIDEO_BACKGROUND_COLOUR;
    
        _homeHighlights = [[UIButton alloc] init];
        [self setPropertiesForButton:_homeHighlights];
        [_homeHighlights setTitle:NSLocalizedString(@"video.highlights", nil) forState:UIControlStateNormal];
        
        _awayHighlights = [[UIButton alloc] init];
        [self setPropertiesForButton:_awayHighlights];
        [_awayHighlights setTitle:NSLocalizedString(@"video.highlights", nil) forState:UIControlStateNormal];
        
//        _homeCondensed = [[UIButton alloc] init];
//        [self setPropertiesForButton:_homeCondensed];
//        [_homeCondensed setTitle:NSLocalizedString(@"video.condensed", nil) forState:UIControlStateNormal];
//        _homeCondensed.tag = 2;
//        
//        _awayCondensed = [[UIButton alloc] init];
//        [self setPropertiesForButton:_awayCondensed];
//        [_awayCondensed setTitle:NSLocalizedString(@"video.condensed", nil) forState:UIControlStateNormal];
//        _awayCondensed.tag = 3;
        
        [self addSubview:_homeHighlights];
        [self addSubview:_awayHighlights];
//        [self addSubview:_homeCondensed];
//        [self addSubview:_awayCondensed];
        
        UIView *topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 1.0/[[UIScreen mainScreen] scale])];
        topline.backgroundColor = ULTRA_LIGHT_GRAY_COLOUR;
        
        [self addSubview:topline];
    }
    
    return self;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect verticalSlice;
    CGRect verticalRemainder;
    
    CGRectDivide(self.frame, &verticalSlice, &verticalRemainder, CGRectGetWidth(self.frame)/2, CGRectMinXEdge);
    
    CGFloat yOffset = 1.0/[[UIScreen mainScreen] scale];
    
    _homeHighlights.frame = CGRectMake(CGRectGetWidth(verticalSlice) + 1.0/[[UIScreen mainScreen] scale], yOffset, CGRectGetWidth(verticalSlice) - 1.0/[[UIScreen mainScreen] scale], CGRectGetHeight(self.frame) - 1.0/[[UIScreen mainScreen] scale] - yOffset);
    
    _awayHighlights.frame = CGRectMake(0, yOffset, CGRectGetWidth(verticalSlice) - 1.0/[[UIScreen mainScreen] scale], CGRectGetHeight(self.frame) - 1.0/[[UIScreen mainScreen] scale] - yOffset);
}

-(void)setSelected:(BOOL)animated {
    
}

-(void)setHighlighted:(BOOL)animated {
    
}

-(void)setPropertiesForButton:(UIButton *)button {
    
    [button setTitleColor:WHITE_COLOUR forState:UIControlStateNormal];
    [button setTitleColor:LIGHT_GRAY_COLOUR forState:UIControlStateHighlighted];
    [button setTitleColor:LIGHT_GRAY_COLOUR forState:UIControlStateSelected];
    [button setTitleColor:LIGHT_GRAY_COLOUR forState:UIControlStateDisabled];
    
    [button setEnabled:NO];
}

-(void)setEnabled:(NSArray *)isEnabled withHomeTeam:(NSString *)homeTeam andAwayTeam:(NSString *)awayTeam {

    [_homeHighlights setBackgroundColor:[TeamHandler getTeamColor:homeTeam]];
    [_homeHighlights setEnabled:[(NSNumber *)isEnabled[0] boolValue]];

    [_awayHighlights setBackgroundColor:[TeamHandler getTeamColor:awayTeam]];
    [_awayHighlights setEnabled:[(NSNumber *)isEnabled[1] boolValue]];
}

@end
