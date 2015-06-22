//
//  BracketSection.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-02.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "BracketSection.h"
#import "BracketView.h"
#import "Rectangle.h"
#import "Colours.h"
#import "Dimensions.h"

@interface BracketSection ()

@property NSArray *fromFrames;
@property NSArray *toFrames;

@end

@implementation BracketSection

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)createBracketFromRound:(enum round)fromRound toRound:(enum round)toRound inCollectionView:(BracketView *)collectionView {

    _fromFrames = [collectionView getFramesForRound:fromRound];
    _toFrames = [collectionView getFramesForRound:toRound];
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawRect:(CGRect)rect {
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [BRACKET_LINE_COLOUR CGColor]);
    CGContextSetLineWidth(context, LINE_WIDTH);
    
    for (int i = 0; i < _fromFrames.count; ++i) {
        
        Rectangle *rectangle = [_fromFrames objectAtIndex:i];
        
        CGContextSaveGState(context);
        
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, rectangle.x + rectangle.width/2, 0);
        CGContextAddLineToPoint(context, rectangle.x + rectangle.width/2, rect.size.height/2);
        
        CGContextStrokePath(context);
        
        CGContextRestoreGState(context);
    }
    
    for (int i = 0; i < _toFrames.count; ++i) {
        
        Rectangle *rectangle = [_toFrames objectAtIndex:i];
        
        CGContextSaveGState(context);
        
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, rectangle.x + rectangle.width/2, rect.size.height/2);
        CGContextAddLineToPoint(context, rectangle.x + rectangle.width/2, rect.size.height);
        
        CGContextStrokePath(context);
        
        CGContextRestoreGState(context);
    }
    
    Rectangle *startRect;
    Rectangle *endRect;
    
    if (_toFrames.count >= _fromFrames.count) {
        
        startRect = [_toFrames firstObject];
        endRect = [_toFrames lastObject];
    }
    
    else {
        
        startRect = [_fromFrames firstObject];
        endRect = [_fromFrames lastObject];
    }
    
    CGContextSaveGState(context);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, startRect.x + startRect.width/2 - LINE_WIDTH/2, rect.size.height/2);
    CGContextAddLineToPoint(context, endRect.x + endRect.width/2 + LINE_WIDTH/2, rect.size.height/2);
    
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}


@end
