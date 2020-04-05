//
//  BracketSection.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-02.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import UIKit;
#import "Enums.h"

@class BracketView;

@interface BracketSection : UICollectionReusableView

-(void)createBracketFromRound:(enum round)fromRound toRound:(enum round)toRound inCollectionView:(BracketView *)collectionView;

@end
