//
//  BracketView.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2/26/2014.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "BracketView.h"
#import "SeriesCell.h"
#import "BracketSection.h"
#import "ReuseIdentifiers.h"
#import "BracketModel.h"
#import "Rectangle.h"
#import "Dimensions.h"

@interface BracketView ()

@property CGSize layoutSize;

@end

@implementation BracketView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame collectionViewLayout:[[self class] getLayout]];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.alwaysBounceVertical = YES;
        
        [self registerClass:[SeriesCell class] forCellWithReuseIdentifier:SERIES_CELL_REUSE_IDENTIFIER];
        [self registerClass:[BracketSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BRACKET_SECTION_REUSE_IDENTIFIER];
    }
    
    return self;
}

-(void)layoutSubviews {
    // Folding can resize the view without a rotation callback.
    if (!CGSizeEqualToSize(_layoutSize, self.bounds.size)) {
        _layoutSize = self.bounds.size;
        [self.collectionViewLayout invalidateLayout];
    }
    [super layoutSubviews];
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    // Bar changes can resize the usable bracket without changing its bounds.
    [self.collectionViewLayout invalidateLayout];
    [self setNeedsLayout];
}

+(UICollectionViewLayout *)getLayout {
    
    return [[UICollectionViewFlowLayout alloc] init];
}

-(CGFloat)layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    CGFloat itemWidth = [self layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]].width;
    
    UIEdgeInsets inset = [self layout:collectionViewLayout insetForSectionAtIndex:section];
    
    NSUInteger rows = [BracketModel numberOfRowsInSection:section];
    
    CGFloat width = CGRectGetWidth(self.bounds) - inset.left - inset.right;
    
    CGFloat interItemSpacing;
    
    switch (section) {
            
        case west_quarter:
        case east_quarter:
            
            if (rows <= 1) {
                interItemSpacing = 10.0;
            }
            
            else {
                
                interItemSpacing = ((width - (rows * itemWidth)) / (rows - 1)) - (itemWidth / (rows - 1));
                
                if (interItemSpacing < 10.0) {
                    interItemSpacing = 10.0;
                }
            }
            
            break;
            
        case west_semi:
        case east_semi: {

            enum round quarterRound = (section == west_semi) ? west_quarter : east_quarter;
            NSArray *quarterFrames = [self getFramesForRound:quarterRound];

            if (rows >= 2 && quarterFrames.count >= 4) {

                Rectangle *q0 = [quarterFrames objectAtIndex:0];
                Rectangle *q1 = [quarterFrames objectAtIndex:1];
                Rectangle *q2 = [quarterFrames objectAtIndex:2];
                Rectangle *q3 = [quarterFrames objectAtIndex:3];

                CGFloat firstSemiCenter = ((q0.x + q0.width/2) + (q1.x + q1.width/2)) / 2.0;
                CGFloat secondSemiCenter = ((q2.x + q2.width/2) + (q3.x + q3.width/2)) / 2.0;

                interItemSpacing = secondSemiCenter - firstSemiCenter - itemWidth;
            }

            else {
                interItemSpacing = 10.0;
            }

            if (interItemSpacing < 10.0) {
                interItemSpacing = 10.0;
            }

            break;
        }
            
        case west_final:
        case east_final:
            
            interItemSpacing = 10.0;
            break;
            
        case final:
            
            interItemSpacing = 10.0;
            break;
            
        default:
            
            interItemSpacing = 10.0;
            break;
    }
    
    return interItemSpacing;
}

-(CGFloat)layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

-(CGSize)layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger rows = [BracketModel numberOfRowsInSection:indexPath.section];
    CGFloat width = floor((CGRectGetWidth(self.bounds) - 2 * SIDE_MARGIN - (rows - 1) * 10.0) / rows);
    
    
    int height = ([self getHeightForView: self] - TOP_MARGIN - BOTTOM_MARGIN - ([BracketModel numberOfSections] - 1) * MIN_SECTION_HEADER_HEIGHT)/[BracketModel numberOfSections];
    
    // Keep series tappable on short windows; scroll rather than shrink them.
    return CGSizeMake(MAX(1.0, MIN(width, 60.0)), MAX(44.0, MIN(height, 55.0)));
}

-(UIEdgeInsets)layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    CGFloat itemWidth = [self layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]].width;
    
    NSInteger numberOfSections = [BracketModel numberOfSections];
    
    CGFloat topOffest;
    CGFloat bottomOffset;
    
    if (section == 0) {
        topOffest = TOP_MARGIN;
        bottomOffset = 0.0;
    }
    
    else if (section == numberOfSections - 1) {
        
        topOffest = 0.0;
        bottomOffset = BOTTOM_MARGIN;
    }
    
    else {
        topOffest = 0.0;
        bottomOffset = 0.0;
    }
    
    CGFloat marginOffset;
    
    switch (section) {
            
        case west_semi:
        case east_semi: {

            enum round quarterRound = (section == west_semi) ? west_quarter : east_quarter;
            NSArray *quarterFrames = [self getFramesForRound:quarterRound];

            if (quarterFrames.count >= 2) {

                Rectangle *q0 = [quarterFrames objectAtIndex:0];
                Rectangle *q1 = [quarterFrames objectAtIndex:1];

                CGFloat firstSemiCenter = ((q0.x + q0.width/2) + (q1.x + q1.width/2)) / 2.0;
                // Leave room for flow layout's pixel rounding between the pair.
                marginOffset = floor(firstSemiCenter - itemWidth/2 - SIDE_MARGIN);
            }

            else {
                marginOffset = itemWidth/2;
            }

            break;
        }
            
        case west_final:
        case east_final:
        case final:
            
            // A single matchup and its connector share the content centerline.
            // Semifinal spacing is unrelated to this inset on wide displays.
            marginOffset = (CGRectGetWidth(self.bounds) - 2 * SIDE_MARGIN - itemWidth)/2;
            break;
            
        default:
            
            marginOffset = 0;
            break;
    }
    
    return UIEdgeInsetsMake(topOffest, SIDE_MARGIN + marginOffset, bottomOffset, SIDE_MARGIN + marginOffset);
}

-(CGSize)layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section > 0) {
        
        NSInteger numberOfSections = [BracketModel numberOfSections];
        
        CGFloat viewHeight = [self getHeightForView: self] - TOP_MARGIN - BOTTOM_MARGIN;
        CGFloat itemHeight = [self layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]].height;
        
        CGFloat lineSpacing = (viewHeight - (itemHeight * numberOfSections)) / (numberOfSections - 1);
        
        return CGSizeMake(CGRectGetWidth(self.bounds), MAX(MIN_SECTION_HEADER_HEIGHT, floor(lineSpacing)));
    }
    
    else {
        return CGSizeZero;
    }
}

-(NSArray *)getFramesForRound:(enum round)round {
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    UIEdgeInsets edgeInset = [self layout:nil insetForSectionAtIndex:round];
    
    CGSize itemSize = [self layout:nil sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:round]];
    
    CGFloat minItemSpacing = [self layout:nil minimumInteritemSpacingForSectionAtIndex:round];
    
    NSInteger numberOfItems = [BracketModel numberOfRowsInSection:round];
    
    CGFloat itemSpacing;
    
    if (numberOfItems == 1) {
        
        itemSpacing = 0.0;
    }
    
    else {
        
        itemSpacing = MAX((CGRectGetWidth(self.bounds) - edgeInset.left - edgeInset.right - numberOfItems * itemSize.width)/MAX(1, numberOfItems-1), minItemSpacing);
    }
    
    for (int i = 0; i < numberOfItems; ++i) {
        
        CGFloat x;
        
        if (numberOfItems == 1) {
            x = edgeInset.left + itemSpacing;
        }
        
        else {
            x = edgeInset.left + itemSpacing * i + itemSize.width * i;
        }
        
        Rectangle *rect = [[Rectangle alloc] init];
        rect.x = x;
        rect.y = 0.0;
        rect.width = itemSize.width;
        rect.height = itemSize.height;
        
        [temp addObject:rect];
    }
    
    return temp;
}

-(CGFloat)getHeightForView:(UIView *)view {
    return view.safeAreaLayoutGuide.layoutFrame.size.height;
}

@end
