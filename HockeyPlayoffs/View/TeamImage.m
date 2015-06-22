//
//  TeamImage.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 12-02-03.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "TeamImage.h"
#import "Colours.h"

@interface TeamImage ()

@property NSDictionary *dict;

@end

@implementation TeamImage

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)getTeamColors:(NSString *)team withSize:(int)size{
    
    NSDictionary *colors = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TeamColors" ofType:@"plist"]];
    
//    NSNumber *redB = [[colors objectForKey:team] objectForKey:@"bottomRed"];
//    NSNumber *greenB = [[colors objectForKey:team] objectForKey:@"bottomGreen"];
//    NSNumber *blueB = [[colors objectForKey:team] objectForKey:@"bottomBlue"];
//    NSNumber *redT = [[colors objectForKey:team] objectForKey:@"topRed"];
//    NSNumber *greenT = [[colors objectForKey:team] objectForKey:@"topGreen"];
//    NSNumber *blueT = [[colors objectForKey:team] objectForKey:@"topBlue"];

    NSNumber *red = [[colors objectForKey:[team uppercaseString]] objectForKey:@"bottomRed"];
    NSNumber *green = [[colors objectForKey:[team uppercaseString]] objectForKey:@"bottomGreen"];
    NSNumber *blue = [[colors objectForKey:[team uppercaseString]] objectForKey:@"bottomBlue"];
    
    NSNumber *textSize = [NSNumber numberWithInt:size];
    
    _dict = [[NSDictionary alloc] initWithObjectsAndKeys:red, @"red", green, @"green", blue, @"blue", team, @"team",textSize,@"size", nil];
    
}

-(void)setSmallImage:(NSString *)team{
    
    [self setImageForTeam:team andSize:9];
    
    [self setNeedsDisplay];
}

-(void)setMediumImage:(NSString *)team{
    
    [self setImageForTeam:team andSize:14];
    
    [self setNeedsDisplay];
}

-(void)setLargeImage:(NSString *)team{
    
    [self setImageForTeam:team andSize:16];
    
    [self setNeedsDisplay];
}

-(void)setImageForTeam:(NSString *)team andSize:(int)size {
    
    [self getTeamColors:team withSize:size];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect frame = CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);
    
    CGColorRef color;
    
    if (_dict == nil) {
//        topColor = CGColorRetain([[UIColor colorWithWhite:0.8 alpha:1.0] CGColor]);
        color = CGColorRetain([[UIColor colorWithWhite:0.9 alpha:1.0] CGColor]);
    }
    
    else {
//        topColor = CGColorRetain([[UIColor colorWithRed:[[_dict objectForKey:@"redT"] floatValue]/255.0 green:[[_dict objectForKey:@"greenT"] floatValue]/255.0 blue:[[_dict objectForKey:@"blueT"] floatValue]/255.0 alpha:1.0] CGColor]);
//        bottomColor = CGColorRetain([[UIColor colorWithRed:[[_dict objectForKey:@"redB"] floatValue]/255.0 green:[[_dict objectForKey:@"greenB"] floatValue]/255.0 blue:[[_dict objectForKey:@"blueB"] floatValue]/255.0 alpha:1.0] CGColor]);

        color = CGColorRetain([[UIColor colorWithRed:[[_dict objectForKey:@"red"] floatValue]/255.0 green:[[_dict objectForKey:@"green"] floatValue]/255.0 blue:[[_dict objectForKey:@"blue"] floatValue]/255.0 alpha:1.0] CGColor]);

    }
    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGFloat locations[] = {0.0, 1.0};
//    
//    NSArray *colors = [NSArray arrayWithObjects:CFBridgingRelease(bottomColor), CFBridgingRelease(topColor), nil];
//    
//    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
//    
//    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
//    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, color);
    CGContextFillEllipseInRect(context, frame);
    CGContextAddEllipseInRect(context, frame);
    CGContextClip(context);
//    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    UIFont *font = [UIFont systemFontOfSize:[[_dict objectForKey:@"size"] intValue]];
    
    NSString *text = [[_dict objectForKey:@"team"] uppercaseString];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, nil];
    
    float xOffset = 0;
    float yOffset = (frame.size.height - [text sizeWithAttributes:attributes].height)/2;
    
    CGContextTranslateCTM(context, xOffset, yOffset);
    
    [text drawInRect:frame withAttributes:attributes];
    
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    CGColorRef strokeColor = CGColorRetain([LIGHT_GRAY_COLOUR CGColor]);
    
    CGContextSetStrokeColorWithColor(context, strokeColor);
    CGContextSetLineWidth(context, 0.7);
    CGContextStrokeEllipseInRect(context, frame);
    CGContextRestoreGState(context);
    
//    CGGradientRelease(gradient);
//    CGColorSpaceRelease(colorSpace);
    CGColorRelease(strokeColor);
    CGColorRelease(color);
}

@end
