//
//  GameDetailCell.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-18.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "GameDetailCell.h"
#import "TeamImage.h"
#import "Colors.h"
#import "Dimensions.h"
#import "EventObject.h"
#import "StrengthIndicator.h"

@interface GameDetailCell ()

@property TeamImage *teamImage;
@property UILabel *timeLabel;
@property UILabel *textLabel;
@property StrengthIndicator *strength;

@end

#define EDGE_OFFSET 40

@implementation GameDetailCell

@synthesize textLabel = _textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = [Colors gameBackgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _teamImage = [[TeamImage alloc] init];
        
        _timeLabel = [[UILabel alloc] init];
        [self setPropertiesForTimeLabel:_timeLabel];
        
        _textLabel = [[UILabel alloc] init];
        [self setPropertiesForTextLabel:_textLabel];
        
        _strength = [[StrengthIndicator alloc] init];
        
        [self.contentView addSubview:_teamImage];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_textLabel];
        [self.contentView addSubview:_strength];
        
        _seperatorView = [[UIView alloc] initWithFrame:CGRectMake(EDGE_OFFSET, 0.0, self.contentView.frame.size.width - EDGE_OFFSET, 1.0/[[UIScreen mainScreen] scale])];
        _seperatorView.backgroundColor = [Colors ultraLightGrayColor];
        
        [self.contentView addSubview:_seperatorView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    [self layoutSubviews];
}

-(void)layoutSubviews {

    [super layoutSubviews];
 
    _teamImage.frame = CGRectMake(DETAIL_GAME_X_OFFSET, DETAIL_GAME_Y_OFFSET, 30, 30);
    
    [_timeLabel sizeToFit];
    
    _timeLabel.frame = CGRectMake(DETAIL_GAME_X_OFFSET, [[self class] height] - _timeLabel.frame.size.height - DETAIL_GAME_Y_OFFSET, _teamImage.frame.size.width, _timeLabel.frame.size.height);
    
    CGRect slice;
    CGRect remainder;
    
    CGRectDivide(self.contentView.frame, &slice, &remainder, _teamImage.frame.size.width + DETAIL_GAME_X_OFFSET + floorf(1.5*DETAIL_GAME_X_OFFSET), CGRectMinXEdge);
    
    [_textLabel sizeToFit];
    
    _textLabel.frame = CGRectMake(remainder.origin.x, floorf(1.5*DETAIL_GAME_Y_OFFSET), remainder.size.width - DETAIL_GAME_X_OFFSET, MIN(_textLabel.frame.size.height,remainder.size.height - 2*floorf(1.5*DETAIL_GAME_Y_OFFSET)));

//TODO:add implement of strength
    _strength.frame = CGRectZero;
    
    _seperatorView.frame = CGRectMake(EDGE_OFFSET, 0.0, self.contentView.frame.size.width - EDGE_OFFSET, 1.0/[[UIScreen mainScreen] scale]);
}

+(CGFloat)height {
    
    return 55;
}

-(void)setPropertiesForTimeLabel:(UILabel *)label {
    
    label.textColor = [Colors gameDetailCellTimeColor];
    label.font = [UIFont systemFontOfSize:TIME_LABEL_FONT_SIZE];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.lineBreakMode = NSLineBreakByWordWrapping;
}

-(void)setPropertiesForTextLabel:(UILabel *)label {
    
    label.textColor = [Colors gameDetailCellTextColor];
    label.font = [UIFont systemFontOfSize:TEXT_LABEL_FONT_SIZE];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByWordWrapping;
}

-(void)setEvent:(EventObject *)event {

    _timeLabel.text = event.time;
    _textLabel.text = event.details;
    
    [_strength setStrength:event.strength];
    [_teamImage setSmallImage:event.teamID];
    
    [self layoutIfNeeded];
}

@end
