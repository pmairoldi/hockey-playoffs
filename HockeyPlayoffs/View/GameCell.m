//
//  GameCell.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-08.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "GameCell.h"
#import "TeamImage.h"
#import "GameObject.h"
#import "TeamHandler.h"
#import "Colors.h"
#import "Dimensions.h"
#import "VideoButton.h"

@interface GameCell ()

@property GameOverviewView *gameOverview;

@end

#define EDGE_OFFSET 11

@implementation GameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        self.contentView.backgroundColor = [Colors gameBackgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _gameOverview = [[GameOverviewView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
        
        _videoButton = _gameOverview.videoButton;
//        _videoView = _gameOverview.videoView;
        
        [self.contentView addSubview:_gameOverview];
        
        _seperatorView = [[UIView alloc] initWithFrame:CGRectMake(EDGE_OFFSET, 0.0, self.contentView.frame.size.width - 2 * EDGE_OFFSET, 1.0/[[UIScreen mainScreen] scale])];
        _seperatorView.backgroundColor = [Colors ultraLightGrayColor];
        
        [self.contentView addSubview:_seperatorView];
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    [_gameOverview setSelected:selected animated:animated];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    
    [_gameOverview setHighlighted:highlighted animated:animated];
}


-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    _gameOverview.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    [_gameOverview layoutSubviews];
    
    _seperatorView.frame = CGRectMake(EDGE_OFFSET, 0.0, self.contentView.frame.size.width - 2 * EDGE_OFFSET, 1/[[UIScreen mainScreen] scale]);
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    [self layoutSubviews];
}

+(CGFloat)height {
    
    return [GameOverviewView height];
}

-(void)setGame:(GameObject *)game {

    [_gameOverview setGame:game];
    
    [self setAccessibilityIdentifier:[NSString stringWithFormat:@"Game-%@", [game getRelativeGameID]]];
}

//-(void)isExpanded:(int)expandedIndex {
//
//    [_gameOverview isExpanded:expandedIndex];
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
}

@end
