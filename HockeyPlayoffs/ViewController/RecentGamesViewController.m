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
        
        self.datepickerQueue = DATE_PICKER_QUEUE;
        
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
  
    _datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    // Compact pickers report no intrinsic width until hosted; reserve enough
    // space for the complete date instead of the minimum touch-target width.
    CGFloat dateWidth = [[UIFontMetrics metricsForTextStyle:UIFontTextStyleBody] scaledValueForValue:144];
    NSLayoutConstraint *dateWidthConstraint = [_datePicker.widthAnchor constraintEqualToConstant:dateWidth];
    dateWidthConstraint.active = YES;
    [_datePicker.heightAnchor constraintGreaterThanOrEqualToConstant:44].active = YES;
    [self registerForTraitChanges:@[[UITraitPreferredContentSizeCategory class]]
                     withHandler:^(__kindof RecentGamesViewController *controller, UITraitCollection *previousTraits) {
        dateWidthConstraint.constant = [[UIFontMetrics metricsForTextStyle:UIFontTextStyleBody] scaledValueForValue:144];
    }];
    UIBarButtonItem *dateItem = [[UIBarButtonItem alloc] initWithCustomView:_datePicker];
    if (@available(iOS 26.0, *)) dateItem.hidesSharedBackground = YES;
    self.navigationItem.rightBarButtonItem = dateItem;
  
    _recentGamesView = [[RecentGamesView alloc] initWithFrame:CGRectZero];
    _recentGamesView.translatesAutoresizingMaskIntoConstraints = false;
    _recentGamesView.delegate = self;
    _recentGamesView.dataSource = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = Colors.refreshControlColor;

    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    
    _recentGamesView.refreshControl = _refreshControl;
    
    [self.view addSubview:_recentGamesView];
    
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [_recentGamesView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [_recentGamesView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor],
        [_recentGamesView.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor],
        [_recentGamesView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
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
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Keep the original loading row without reserving an empty leading group.
    return [_recentGamesModel numberOfRowsInSection:0] + [_recentGamesModel numberOfRowsInSection:1];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [_recentGamesModel numberOfRowsInSection:0]) {
        return [RefreshTableViewCell height];
    }
    return [GameCell height];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [_recentGamesModel numberOfRowsInSection:0]) {
        return [tableView dequeueReusableCellWithIdentifier:REFRESH_CELL_REUSE_IDENTIFIER];
    }
    NSIndexPath *gameIndex = [self gameIndexForTableIndex:indexPath];
    GameCell *cell = [tableView dequeueReusableCellWithIdentifier:GAME_CELL_REUSE_IDENTIFIER];
    cell.showsBottomSeparator = indexPath.row + 1 < [self tableView:tableView numberOfRowsInSection:indexPath.section];
    cell.videoButton.tag = gameIndex.row;
    [cell setGame:[_recentGamesModel getGameAtIndex:gameIndex]];
    [cell.videoButton removeTarget:self action:@selector(videoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.videoButton addTarget:self action:@selector(videoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Clip the whole group, including the loading row, at its outer corners.
    CACornerMask corners = 0;
    if (indexPath.row == 0) corners |= kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        corners |= kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    }
    cell.layer.cornerRadius = 24;
    cell.layer.cornerCurve = kCACornerCurveContinuous;
    cell.layer.maskedCorners = corners;
    cell.clipsToBounds = YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [_recentGamesModel numberOfRowsInSection:0]) return;
    [self goToGameAtIndexPath:[self gameIndexForTableIndex:indexPath]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSIndexPath *)gameIndexForTableIndex:(NSIndexPath *)indexPath {
    return [NSIndexPath indexPathForRow:indexPath.row - [_recentGamesModel numberOfRowsInSection:0] inSection:1];
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
    [APIRequestHandler getPlayoffs:^(id responseObject, NSError *error, BOOL hasNewData) {
        [weakSelf.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }];
}

-(void)dismissVideoPlayer:(NSNotification *)notification {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

@end
