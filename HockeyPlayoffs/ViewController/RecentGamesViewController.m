//
//  RecentGamesViewController.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2/23/2014.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "RecentGamesViewController.h"
#import "Colours.h"
#import "Rotation.h"
#import "APIRequestHandler.h"
#import "GameCell.h"
#import "ReuseIdentifiers.h"
#import "Colours.h"
#import "GameViewController.h"
#import "GameModel.h"
#import "Rotation.h"
#import "SeriesObject.h"
#import "VideoPlayerViewController.h"
#import "GameObject.h"
#import "VideoButton.h"
#import "RefreshTableViewCell.h"
#import "NoDataTableViewCell.h"
#import "APIRequestHandler.h"
#import "RecentGamesView.h"
#import "RecentGamesModel.h"
#import <LSWeekView/LSWeekView.h>
#import "AdjustableNavigationBar.h"

@interface RecentGamesViewController ()

@property UIRefreshControl *refreshControl;
@property RecentGamesView *recentGamesView;
@property RecentGamesModel *recentGamesModel;
@property LSWeekView *datePicker;

@end

@implementation RecentGamesViewController

#define NavBarHeight 85.0

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        _recentGamesModel = [[RecentGamesModel alloc] init];

        self.title = NSLocalizedString(@"controller.recent.title", nil);
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = BACKGROUND_COLOUR;

    AdjustableNavigationBar *navBar = (AdjustableNavigationBar *)self.navigationController.navigationBar;
    navBar.height = NavBarHeight;
    [self.navigationController.navigationBar sizeToFit];

    _datePicker = [[LSWeekView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 90) style:LSWeekViewStyleDefault];
    _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _datePicker.calendar = [NSCalendar currentCalendar];
    _datePicker.tintColor = SEGEMENT_TINT_COLOUR;
    _datePicker.selectedDate = _recentGamesModel.date;
    //    _datePicker.backgroundColor = [UIColor redColor];
    
    UIView *titleView = [UIView new];
    titleView.frame = _datePicker.frame;
    
    [titleView addSubview:_datePicker];
    
    [self.navigationItem setTitleView:_datePicker];
    [self.navigationItem.titleView sizeToFit];

    _recentGamesView = [[RecentGamesView alloc] initWithFrame:self.view.frame];
    _recentGamesView.delegate = self;
    _recentGamesView.dataSource = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor whiteColor];
    
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    
    [_recentGamesView addSubview:_refreshControl];
    
    [self.view addSubview:_recentGamesView];
    
    __weak typeof(self) weakSelf = self;
    _datePicker.didChangeSelectedDateBlock = ^(NSDate *selectedDate) {
        
        if ([selectedDate compare:weakSelf.recentGamesModel.date] != NSOrderedSame) {
            weakSelf.recentGamesModel.date = selectedDate;
            weakSelf.recentGamesView.hasContent = weakSelf.recentGamesModel.hasData;
            [weakSelf.recentGamesView reloadData];
        }
    };

    _recentGamesView.hasContent = _recentGamesModel.hasData;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [_datePicker reloadData];
    
    CGRect titleViewFrame = self.navigationItem.titleView.frame;
    titleViewFrame.origin.y = 3.5;
    self.navigationItem.titleView.frame = titleViewFrame;
    
    AdjustableNavigationBar *navBar = (AdjustableNavigationBar *)self.navigationController.navigationBar;
    navBar.height = NavBarHeight;
    
    CGRect animatedFrame = self.recentGamesView.frame;
    animatedFrame.origin.y = 0;
    
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
    }
    
    [self.navigationController.navigationBar sizeToFit];
    self.recentGamesView.frame = animatedFrame;
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:-18 forBarMetrics:UIBarMetricsDefault];

    if (animated) {
        [UIView commitAnimations];
    }
    
    [self refresh];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
        
    //smoothen when it is quickly let go
    AdjustableNavigationBar *navBar = (AdjustableNavigationBar *)self.navigationController.navigationBar;
    navBar.height = 44;
    CGRect animatedFrame = self.recentGamesView.frame;
    animatedFrame.origin.y = -navBar.height + 3;
    
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
    }
    
    [self.navigationController.navigationBar sizeToFit];
    self.recentGamesView.frame = animatedFrame;
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];

    if (animated) {
        [UIView commitAnimations];
    }
}

-(void)refresh {
    
    [super refresh];
    
    [_recentGamesModel refresh:^(BOOL reload) {
        
        _recentGamesView.hasContent = _recentGamesModel.hasData;
        [_recentGamesView reloadData];
        
        [_refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Table View Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_recentGamesModel numberOfSections];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_recentGamesModel numberOfRowsInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && _recentGamesModel.isRefreshing) {
        
        return [RefreshTableViewCell height];
    }
    
    else if (indexPath.section == 0 && !_recentGamesModel.isRefreshing) {
        
        return [NoDataTableViewCell height];
    }
    
    else {
        return [GameCell height];
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && _recentGamesModel.isRefreshing) {
        
        return [RefreshTableViewCell height];
    }
    
    else if (indexPath.section == 0 && !_recentGamesModel.isRefreshing) {
        
        return [NoDataTableViewCell height];
    }
    
    else {
        return [GameCell height];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && _recentGamesModel.isRefreshing) {
        
        RefreshTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REFRESH_CELL_REUSE_IDENTIFIER];
        
        return cell;
    }
    
    else if (indexPath.section == 0 && !_recentGamesModel.isRefreshing) {
        
        NoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NO_DATA_CELL_REUSE_IDENTIFIER];
        
        cell.textLabel.text = NSLocalizedString(@"series.nodata", nil);
        
        return cell;
    }
    
    else {
        
        GameCell *cell = [tableView dequeueReusableCellWithIdentifier:GAME_CELL_REUSE_IDENTIFIER];
        cell.videoButton.tag = indexPath.row;
        
        [cell setGame:[_recentGamesModel getGameAtIndex:indexPath]];
        
        [cell.videoButton addTarget:self action:@selector(videoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if(indexPath.row == 0){
            cell.seperatorView.hidden = YES;
        }
        
        else {
            cell.seperatorView.hidden = NO;
        }
                
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.contentView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
    }
    
    else {
        
        [self goToGameAtIndexPath:indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)goToGameAtIndexPath:(NSIndexPath *)indexPath {
    
    GameObject *game = [_recentGamesModel getGameAtIndex:indexPath];
    
    GameViewController *controller = [[GameViewController alloc] initWithGame:game];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)videoButtonTapped:(VideoButton *)sender {
    
    if ([sender tag] == NSNotFound || [sender tag] >= [_recentGamesModel getGames].count) {
        return;
    }
    
    GameObject *game = [_recentGamesModel getGameAtIndex:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    
    NSURL *videoURL = [[game videoLinks] firstObject];
    
    [VideoPlayerViewController showVideo:videoURL inController:self.navigationController];
}

#pragma refresh data

-(void)reloadData:(id)sender {
    
    [APIRequestHandler getPlayoffsWithData:nil completion:^(id responseObject, NSError *error, BOOL hasNewData) {
        
        [_refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }];
}

@end
