//
//  NoContentTableView.m
//  HockeyPlayoffs
//
//  Created by Pierre-Marc Airoldi on 2015-04-14.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "NoContentTableView.h"

@interface NoContentTableView ()

@property UILabel *noContentLabel;

@end

@implementation NoContentTableView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }

    _noContentLabel = [UILabel new];
    _noContentLabel.frame = CGRectMake(10, 10, CGRectGetWidth(frame) - 20, CGRectGetHeight(frame) - 20);
    _noContentLabel.font = [UIFont systemFontOfSize:18.0];
    _noContentLabel.textColor = [UIColor whiteColor];
    _noContentLabel.textAlignment = NSTextAlignmentCenter;
    
    [self insertSubview:_noContentLabel atIndex:0];
    
    self.hasContent = NO;

    return self;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    _noContentLabel.frame = self.bounds;
}

-(void)setNoContentText:(NSString *)noContentText {
    _noContentText = noContentText;
    _noContentLabel.text = _noContentText;
}

-(void)setHasContent:(BOOL)hasContent {
    _hasContent = hasContent;
    _noContentLabel.alpha = hasContent ? 0.0 : 1.0;
}

@end
