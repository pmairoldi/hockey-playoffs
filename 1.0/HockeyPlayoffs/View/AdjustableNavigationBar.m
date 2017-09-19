//
//  AdjustableNavigationBar.m
//  HockeyPlayoffs
//
//  Created by Pierre-Marc Airoldi on 2015-04-15.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "AdjustableNavigationBar.h"

@implementation AdjustableNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }

    [self commonInit];

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];

    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit {
    
    _height = self.frame.size.height;
}

- (CGSize)sizeThatFits:(CGSize)size {

    CGSize newSize = [super sizeThatFits:size];
    // Change navigation bar height. The height must be even, otherwise there will be a white line above the navigation bar.
    newSize.height = self.height;
    
    return newSize;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    for (UIView *view in [self subviews]) {
        
        if ([NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarBackIndicatorView"]) {
            
            CGRect frame = [view frame];
            frame.origin.y = (CGRectGetHeight(frame)/2) + 1;
            [view setFrame:frame];
        
            break;
        }
    }
}

@end
