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

+(UICollectionViewLayout *)getLayout {
    
    return [[UICollectionViewFlowLayout alloc] init];
}

-(CGFloat)layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    CGFloat itemWidth = [self layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]].width;
    
    UIEdgeInsets inset = [self layout:collectionViewLayout insetForSectionAtIndex:section];
    
    NSUInteger rows = [BracketModel numberOfRowsInSection:section];
    
    CGFloat width = CGRectGetWidth(self.frame) - inset.left - inset.right;
    
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
            case east_semi:
            
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
    
    int width = (self.frame.size.width - 2 * SIDE_MARGIN - [BracketModel numberOfRowsInSection:indexPath.section] * 10.0)/[BracketModel numberOfRowsInSection:indexPath.section];
  
    int height = (self.frame.size.height - TOP_MARGIN - BOTTOM_MARGIN - ([BracketModel numberOfSections] - 1) * MIN_SECTION_HEADER_HEIGHT)/[BracketModel numberOfSections];
    
    return CGSizeMake(MIN(width, 60.0), MIN(height, 55.0));
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
    
    int marginOffset;
    
    switch (section) {
            
            case west_semi:
            case east_semi:

            marginOffset = itemWidth/2 + [self layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:west_quarter]/MAX(1, [BracketModel numberOfRowsInSection:section]);
            break;
            
            case west_final:
            case east_final:
            case final:

            marginOffset = MAX((self.frame.size.width - 2 * SIDE_MARGIN - itemWidth)/2,[self layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:west_semi]);
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

        CGFloat viewHeight = self.frame.size.height - TOOLBAR_HEIGHT - STATUS_BAR_HEIGHT - TOP_MARGIN - BOTTOM_MARGIN;
        CGFloat itemHeight = [self layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]].height;

        CGFloat lineSpacing = (viewHeight - (itemHeight * numberOfSections)) / (numberOfSections - 1);

        return CGSizeMake(self.frame.size.width, ceilf(lineSpacing));
    }
    
    else {
        return CGSizeZero;
    }
}

-(NSArray *)getFramesForRound:(enum round)round {
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    UIEdgeInsets edgeInset = [self layout:nil insetForSectionAtIndex:round];

    CGSize itemSize = [self layout:nil sizeForItemAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
    
    CGFloat minItemSpacing = [self layout:nil minimumInteritemSpacingForSectionAtIndex:round];

    NSInteger numberOfItems = [BracketModel numberOfRowsInSection:round];
    
    CGFloat itemSpacing;
    
    if (numberOfItems == 1) {
        
        itemSpacing = 0.0;
    }
    
    else {
    
        itemSpacing = MAX((self.frame.size.width - edgeInset.left - edgeInset.right - numberOfItems * itemSize.width)/MAX(1, numberOfItems-1), minItemSpacing);
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
