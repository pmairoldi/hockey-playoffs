//
//  VideoButton.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-26.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "VideoButton.h"
#import "Colors.h"
#import "Dimensions.h"

@interface VideoButton ()

@end

@implementation VideoButton

@synthesize tintColor = _tintColor;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.tintColor = [Colors videoButtonUnselectedColor];
    }
    
    return self;
}

-(void)setEnabled:(BOOL)enabled {
    
    [super setEnabled:enabled];
    
    if (!self.enabled) {
        self.tintColor = [Colors videoButtonDisabledColor];
    }
    
    else if (self.selected) {
        self.tintColor = [Colors videoButtonSelectedColor];
    }
    
    else {
        self.tintColor = [Colors videoButtonUnselectedColor];
    }

    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)selected {

    [super setSelected:selected];
    
    if (!self.enabled) {
        self.tintColor = [Colors videoButtonDisabledColor];
    }
    
    else if (self.selected) {
        self.tintColor = [Colors videoButtonSelectedColor];
    }
    
    else {
        self.tintColor = [Colors videoButtonUnselectedColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted {
    
    [super setHighlighted:highlighted];
    
    if (!self.enabled) {
        self.tintColor = [Colors videoButtonDisabledColor];
    }
    
    else if (self.highlighted) {
        self.tintColor = [Colors videoButtonSelectedColor];
    }
    
    else {
        self.tintColor = [Colors videoButtonUnselectedColor];
    }
}

-(void)setTintColor:(UIColor *)tintColor {

    _tintColor = tintColor;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect screenRect;
    CGRect lineRect;
    
    CGRectDivide(rect, &lineRect, &screenRect, rect.size.height * 0.3, CGRectMaxYEdge);

    CGRect screenRectInset = CGRectInset(screenRect, VIDEO_LINE_HEIGHT, VIDEO_LINE_HEIGHT);
    
    CGContextAddRect(context, screenRect);
    CGContextAddRect(context, screenRectInset);
    
    CGRect lineRectInset = CGRectInset(lineRect, rect.size.width * 0.2, 0.0);
    CGRect lineRectFinal = CGRectMake(CGRectGetMinX(lineRectInset), CGRectGetMidY(lineRectInset) - VIDEO_LINE_HEIGHT/2, CGRectGetWidth(lineRectInset), VIDEO_LINE_HEIGHT);
    
    CGContextAddRect(context, lineRectFinal);

    CGContextSetFillColorWithColor(context, [self.tintColor CGColor]);
    CGContextEOFillPath(context);
}


@end
