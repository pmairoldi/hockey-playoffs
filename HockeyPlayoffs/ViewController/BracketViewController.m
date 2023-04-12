//
//  BracketViewController.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2/23/2014.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "BracketViewController.h"
#import "BracketView.h"
#import "BracketModel.h"
#import "SeriesCell.h"
#import "BracketSection.h"
#import "ReuseIdentifiers.h"
#import "SeriesViewController.h"
#import "Images.h"
#import "Colors.h"
#import "Rotation.h"
#import "SeriesObject.h"
#import "APIRequestHandler.h"

@interface BracketViewController ()

@property UIRefreshControl *refreshControl;
@property BracketView *bracketView;
@property BracketModel *bracketModel;
@property CAGradientLayer *gradient;

@end

@implementation BracketViewController

-(id)init {
    
    self = [super init];
    
    if (self) {
        // Custom initialization
        
        _bracketModel = [[BracketModel alloc] init];
        
        self.title = NSLocalizedString(@"controller.bracket.title", nil);
    }
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [Colors backgroundColor];
    
    _bracketView = [[BracketView alloc] initWithFrame:self.view.frame];
    _bracketView.delegate = self;
    _bracketView.dataSource = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGFloat topGradientPercent = (CGRectGetHeight(statusBarFrame) - 2.0) / CGRectGetHeight(self.view.bounds);
    CGFloat bottomGradientPercent = (CGRectGetHeight(statusBarFrame) + 8.0) / CGRectGetHeight(self.view.bounds);

    _gradient = [CAGradientLayer layer];
    _gradient.frame = self.view.bounds;
    _gradient.colors = @[(id)[[UIColor clearColor] CGColor], (id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor]];
    _gradient.locations = @[@(0.0), @(topGradientPercent), @(bottomGradientPercent), @(1.0)];
    _gradient.opacity = 1.0;
    
    [_bracketView addSubview:_refreshControl];
    self.view.layer.mask = _gradient;
    
    [self.view addSubview:_bracketView];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self refresh];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

-(void)refresh {
    
    [super refresh];
    
    __weak BracketViewController *weakSelf = self;
    [_bracketModel refresh:^(BOOL reload) {
        [weakSelf.bracketView reloadData];
        [weakSelf.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [_bracketView reloadData];
}

-(void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma status bar methods

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma Scoll View Mehtods

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - 10.0;
//
//    [UIView beginAnimations:nil context:NULL];
//    
//    if (scrollView.contentOffset.y > 0) {
//        _gradient.opacity = scrollView.contentOffset.y > offset ? 1.0 : (scrollView.contentOffset.y / offset);
//    }
//    
//    else {
//        _gradient.opacity = 0.0;
//    }
//    
//    [UIView commitAnimations];
//}

#pragma collection view methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [BracketModel numberOfSections];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [BracketModel numberOfRowsInSection:section];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SeriesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SERIES_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    
    [cell setRefresh:_bracketModel.isRefreshing];
    [cell setSeries:[_bracketModel getSeriesAtIndex:indexPath]];
    [cell setTodayIndicator:[_bracketModel hasGameTodayAtIndex:indexPath]];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    BracketSection *bracket = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BRACKET_SECTION_REUSE_IDENTIFIER forIndexPath:indexPath];
    
    switch (indexPath.section) {
       
        case west_semi:
            
            [bracket createBracketFromRound:west_quarter toRound:west_semi inCollectionView:(BracketView *)collectionView];
            break;
            
        case west_final:
            
            [bracket createBracketFromRound:west_semi toRound:west_final inCollectionView:(BracketView *)collectionView];
            break;
            
        case final:
            
            [bracket createBracketFromRound:west_final toRound:final inCollectionView:(BracketView *)collectionView];
            break;

        case east_final:
            
            [bracket createBracketFromRound:final toRound:east_final inCollectionView:(BracketView *)collectionView];
            break;

        case east_semi:
            
            [bracket createBracketFromRound:east_final toRound:east_semi inCollectionView:(BracketView *)collectionView];
            break;

        case east_quarter:
            
            [bracket createBracketFromRound:east_semi toRound:east_quarter inCollectionView:(BracketView *)collectionView];
            break;
            
        default:

            break;
    }
    
    return bracket;
}

#pragma Collection View Layout Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return [_bracketView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return [_bracketView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return [_bracketView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [_bracketView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return [_bracketView layout:collectionViewLayout insetForSectionAtIndex:section];
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SeriesCell *cell = (SeriesCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell setNeedsDisplay];
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
 
    SeriesCell *cell = (SeriesCell *)[collectionView cellForItemAtIndexPath:indexPath];

    [cell setNeedsDisplay];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    SeriesCell *cell = (SeriesCell *)[collectionView cellForItemAtIndexPath:indexPath];

    [cell setNeedsDisplay];

    [self goToSeriesAtIndexPath:indexPath];

    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

    SeriesCell *cell = (SeriesCell *)[collectionView cellForItemAtIndexPath:indexPath];

    [cell setNeedsDisplay];
}

-(void)goToSeriesAtIndexPath:(NSIndexPath *)indexPath {
    
    SeriesObject *series = [_bracketModel getSeriesAtIndex:indexPath];
    
    SeriesViewController *controller = [[SeriesViewController alloc] initWithSeries:series];
        
    [self.navigationController pushViewController:controller animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma refresh data

-(void)reloadData:(id)sender {
    __weak BracketViewController *weakSelf = self;
    [APIRequestHandler getPlayoffsWithData:nil completion:^(id responseObject, NSError *error, BOOL hasNewData) {
        [weakSelf.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }];
}

@end
