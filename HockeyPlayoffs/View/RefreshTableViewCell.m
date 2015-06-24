//
//  RefreshTableViewCell.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-06.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "RefreshTableViewCell.h"
#import "Colors.h"

@interface RefreshTableViewCell ()

@property UIActivityIndicatorView *activityIndicator;

@end

@implementation RefreshTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        self.contentView.backgroundColor = [Colors gameBackgroundColor];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator startAnimating];
        
        [self.contentView addSubview:_activityIndicator];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

-(void)layoutSubviews {
    
    [super layoutSubviews];

    _activityIndicator.center = CGPointMake(CGRectGetWidth(self.contentView.frame)/2, CGRectGetHeight(self.contentView.frame)/2);
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    [self layoutSubviews];
}

+(CGFloat)height {
    
    return 44;
}

@end
