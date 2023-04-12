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
#import "Queues.h"

@interface RecentGamesViewController ()

@property UIRefreshControl *refreshControl;
@property RecentGamesView *recentGamesView;
@property RecentGamesModel *recentGamesModel;
@property UIDatePicker *datePicker;
@property dispatch_queue_t datepickerQueue;

@end

@implementation RecentGamesViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            self.datepickerQueue = DATE_PICKER_QUEUE;
        });
        
        _recentGamesModel = [[RecentGamesModel alloc] init];
        
        self.title = NSLocalizedString(@"controller.recent.title", nil);
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [Colors backgroundColor];
  
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.preferredDatePickerStyle = UIDatePickerStyleCompact;
    _datePicker.tintColor = [Colors tintColor];
    _datePicker.date = _recentGamesModel.date;
    [_datePicker addTarget:self action:@selector(onDateChange:) forControlEvents:UIControlEventValueChanged];
  
    self.navigationItem.titleView = _datePicker;
  
    _recentGamesView = [[RecentGamesView alloc] initWithFrame:CGRectZero];
    _recentGamesView.translatesAutoresizingMaskIntoConstraints = false;
    _recentGamesView.delegate = self;
    _recentGamesView.dataSource = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor whiteColor];
    
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    
    [_recentGamesView addSubview:_refreshControl];
    
    [self.view addSubview:_recentGamesView];
    
    [_recentGamesView.topAnchor constraintEqualToAnchor: self.view.topAnchor].active = true;
    [_recentGamesView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor].active = true;
    [_recentGamesView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor].active = true;
    [_recentGamesView.bottomAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.bottomAnchor].active = true;
    
    _recentGamesView.hasContent = _recentGamesModel.hasData;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissVideoPlayer:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
            
    [self refresh];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refresh {
    
    [super refresh];
    
    __weak RecentGamesViewController *weakSelf = self;
    [_recentGamesModel refresh:^(BOOL reload) {
        weakSelf.recentGamesView.hasContent = weakSelf.recentGamesModel.hasData;
        [weakSelf.recentGamesView reloadData];
        [weakSelf.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }];
}

-(void)onDateChange:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
      
    __weak typeof(self) weakSelf = self;
    dispatch_async(weakSelf.datepickerQueue, ^{
        if ([selectedDate compare: weakSelf.recentGamesModel.date] != NSOrderedSame) {
          weakSelf.recentGamesModel.date = selectedDate;
          BOOL hasContent = weakSelf.recentGamesModel.hasData;
          dispatch_async(dispatch_get_main_queue(), ^{
              weakSelf.recentGamesView.hasContent = hasContent;
              [weakSelf.recentGamesView reloadData];
          });
        }
    });
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
    
    AVPlayerViewController *playerController = [VideoPlayerViewController playerWithUrl:videoURL];
    [self.navigationController presentViewController:playerController animated:YES completion:nil];
}

#pragma refresh data

-(void)reloadData:(id)sender {
    __weak RecentGamesViewController *weakSelf = self;
    [APIRequestHandler getPlayoffsWithData:nil completion:^(id responseObject, NSError *error, BOOL hasNewData) {
        [weakSelf.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }];
}

-(void)dismissVideoPlayer:(NSNotification *)notification {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

@end
