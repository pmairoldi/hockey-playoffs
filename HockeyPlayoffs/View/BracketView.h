//
//  BracketView.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2/26/2014.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import UIKit;
#import "Enums.h"

@interface BracketView : UICollectionView

+(UICollectionViewLayout *)getLayout;

-(CGFloat)layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
-(CGFloat)layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
-(CGSize)layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
-(UIEdgeInsets)layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
-(CGSize)layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
-(NSArray *)getFramesForRound:(enum round)round;

@end
