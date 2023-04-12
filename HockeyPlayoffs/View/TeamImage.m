//
//  TeamImage.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 12-02-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "TeamImage.h"
#import "Colors.h"
#import "TeamHandler.h"

@interface TeamImage ()

@property NSString *teamABR;
@property UIColor *color;
@property int textSize;

@end

@implementation TeamImage

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _color = [Colors teamImageDefaultColor];
    }
    
    return self;
}

-(void)setSmallImage:(NSString *)teamABR {
    
    [self setImageForTeam:teamABR andSize:9];
}

-(void)setMediumImage:(NSString *)teamABR {
    
    [self setImageForTeam:teamABR andSize:14];
}

-(void)setLargeImage:(NSString *)teamABR {
    
    [self setImageForTeam:teamABR andSize:16];
}

-(void)setImageForTeam:(NSString *)teamABR andSize:(int)size {
    
    _teamABR = teamABR;
    _color = [TeamHandler getTeamColor:teamABR];
    _textSize = size;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect frame = CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);
    
    CGColorRef color = CGColorRetain(_color.CGColor);
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, color);
    CGContextFillEllipseInRect(context, frame);
    CGContextAddEllipseInRect(context, frame);
    CGContextClip(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    UIFont *font = [UIFont systemFontOfSize:_textSize];
    
    NSString *text = [_teamABR uppercaseString];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, nil];
    
    float xOffset = 0;
    float yOffset = (frame.size.height - [text sizeWithAttributes:attributes].height)/2;
    
    CGContextTranslateCTM(context, xOffset, yOffset);
    
    [text drawInRect:frame withAttributes:attributes];
    
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    CGColorRef strokeColor = CGColorRetain([[Colors teamImageStrokeColor] CGColor]);
    
    CGContextSetStrokeColorWithColor(context, strokeColor);
    CGContextSetLineWidth(context, 0.7);
    CGContextStrokeEllipseInRect(context, frame);
    CGContextRestoreGState(context);
    
    CGColorRelease(strokeColor);
    CGColorRelease(color);
}

@end
