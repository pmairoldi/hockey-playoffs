//
//  GameDetailHeader.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-21.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "GameDetailHeader.h"
#import "Colours.h"
#import "Dimensions.h"

@interface GameDetailHeader ()

@property UILabel *textLabel;

@end

@implementation GameDetailHeader

@synthesize textLabel = _textLabel;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
//        self.contentView.backgroundColor = GAME_DETAIL_HEADER_BACKGROUND_COLOUR;
        
        _textLabel = [[UILabel alloc] init];
        [self setPropertiesForTextLabel:_textLabel];
        
        self.contentView.backgroundColor = GAME_DETAIL_HEADER_BACKGROUND_COLOUR;
        [self.contentView addSubview:_textLabel];
    }
    
    return self;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    _textLabel.frame = CGRectMake(floor(1.5*DETAIL_GAME_X_OFFSET), 0, self.contentView.frame.size.width - 2*floor(1.5*DETAIL_GAME_X_OFFSET), self.contentView.frame.size.height);
}

-(void)setPropertiesForTextLabel:(UILabel *)label {
    
    label.textColor = GAME_DETAIL_HEADER_TEXT_COLOUR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:DETAIL_GAME_HEADER_FONT_SIZE];
    label.adjustsFontSizeToFitWidth = YES;
    label.lineBreakMode = NSLineBreakByWordWrapping;
}

+(CGFloat)height {
    
    return 20;
}

-(void)setPeriod:(NSString *)period {
 
    self.textLabel.text = period;
}

@end
