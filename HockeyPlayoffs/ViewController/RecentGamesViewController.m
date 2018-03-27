//
//  RecentGamesViewController.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2/23/2014.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "RecentGamesViewController.h"
#import "Colors.h"
#import "Rotation.h"
#import "APIRequestHandler.h"
#import "GameCell.h"
#import "ReuseIdentifiers.h"
#import "Colors.h"
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
#import "Queues.h"

@interface RecentGamesViewController ()

@property UIRefreshControl *refreshControl;
@property RecentGamesView *recentGamesView;
@property RecentGamesModel *recentGamesModel;
@property LSWeekView *datePicker;
@property dispatch_queue_t datepickerQueue;

@end

@implementation RecentGamesViewController

#define NavBarHeight 85.0

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            _datepickerQueue = DATE_PICKER_QUEUE;
        });
        
        _recentGamesModel = [[RecentGamesModel alloc] init];
        
        self.title = NSLocalizedString(@"controller.recent.title", nil);
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [Colors backgroundColor];
    
    [self.navigationController setNavigationBarHidden:true animated:false];
    
    UIVisualEffectView *_datePickerView = [self createDatePickerView];
    
    _datePicker = [[LSWeekView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), CGRectGetWidth(self.view.frame), 90) style:LSWeekViewStyleDefault];
    _datePicker.center = CGPointMake(self.view.center.x, _datePicker.center.y);
    _datePicker.calendar = [NSCalendar currentCalendar];
    _datePicker.tintColor = [Colors segmentTintColor];
    _datePicker.selectedDate = _recentGamesModel.date;
    
    [_datePickerView.contentView addSubview:_datePicker];
    
    _recentGamesView = [[RecentGamesView alloc] initWithFrame:CGRectZero];
    _recentGamesView.translatesAutoresizingMaskIntoConstraints = false;
    _recentGamesView.delegate = self;
    _recentGamesView.dataSource = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor whiteColor];
    
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    
    [_recentGamesView addSubview:_refreshControl];
    
    [self.view addSubview:_datePickerView];
    [self.view addSubview:_recentGamesView];
    
    [_datePickerView.topAnchor constraintEqualToAnchor: self.view.topAnchor].active = true;
    [_datePickerView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor].active = true;
    [_datePickerView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor].active = true;
    [_datePickerView.bottomAnchor constraintEqualToAnchor: _datePicker.bottomAnchor constant: 8.0].active = true;
    
    [_recentGamesView.topAnchor constraintEqualToAnchor: _datePickerView.bottomAnchor].active = true;
    [_recentGamesView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor].active = true;
    [_recentGamesView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor].active = true;
    [_recentGamesView.bottomAnchor constraintEqualToAnchor: self.bottomLayoutGuide.topAnchor].active = true;
    
    __weak typeof(self) weakSelf = self;
    _datePicker.didChangeSelectedDateBlock = ^(NSDate *selectedDate) {
        
        dispatch_async(weakSelf.datepickerQueue, ^{
            
            if ([selectedDate compare:weakSelf.recentGamesModel.date] != NSOrderedSame) {
                
                weakSelf.recentGamesModel.date = selectedDate;
                BOOL hasContent = weakSelf.recentGamesModel.hasData;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.recentGamesView.hasContent = hasContent;
                    [weakSelf.recentGamesView reloadData];
                });
            }
        });
    };
    
    _recentGamesView.hasContent = _recentGamesModel.hasData;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:animated];
    
    [_datePicker reloadData];
    
    [self refresh];
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

-(UIVisualEffectView *)createDatePickerView {
    
    UIVisualEffect *effect;
    effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    visualEffectView.translatesAutoresizingMaskIntoConstraints = false;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    UIView *border = [[UIView alloc] initWithFrame:CGRectZero];
    border.translatesAutoresizingMaskIntoConstraints = false;
    border.backgroundColor = [UIColor colorWithWhite:216/255.0 alpha:1.0];
    
    [visualEffectView.contentView addSubview:border];
    
    [border.leadingAnchor constraintEqualToAnchor:visualEffectView.leadingAnchor].active = true;
    [border.trailingAnchor constraintEqualToAnchor:visualEffectView.trailingAnchor].active = true;
    [border.topAnchor constraintEqualToAnchor:visualEffectView.bottomAnchor constant: -1.0].active = true;
    [border.heightAnchor constraintEqualToConstant:1.0].active = true;
    
    return visualEffectView;
}

@end
