//
//  GameViewController.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-18.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "GameViewController.h"
#import "GameModel.h"
#import "GameView.h"
#import "ReuseIdentifiers.h"
#import "Colors.h"
#import "GameHeader.h"
#import "GameDetailCell.h"
#import "GameDetailHeader.h"
#import "VideoButton.h"
#import "VideoPlayerViewController.h"
#import "Rotation.h"
#import "RefreshTableViewCell.h"
#import "GameObject.h"
#import "NoDataTableViewCell.h"
#import "APIRequestHandler.h"

@interface GameViewController ()

@property UIRefreshControl *refreshControl;
@property GameView *gameView;
@property GameModel *gameModel;

@end

@implementation GameViewController

-(id)initWithGame:(GameObject *)game {
    
    self = [super init];
    
    if (self) {
        
        _gameModel = [GameModel initWithGame:game];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [_gameModel getTitle];
    self.view.backgroundColor = [Colors backgroundColor];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
    _gameView = [[GameView alloc] initWithFrame:CGRectZero];
    _gameView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _gameView.delegate = self;
    _gameView.dataSource = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = Colors.refreshControlColor;

    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    
    _gameView.refreshControl = _refreshControl;
    
    [self.view addSubview:_gameView];
    // Let content scroll to the display edges; UIKit adjusts the resting
    // content/indicator insets for navigation, device corners, and system bars.
    [NSLayoutConstraint activateConstraints:@[
        [_gameView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [_gameView.leadingAnchor constraintEqualToAnchor:self.view.readableContentGuide.leadingAnchor constant:-16],
        [_gameView.trailingAnchor constraintEqualToAnchor:self.view.readableContentGuide.trailingAnchor constant:16],
        [_gameView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissVideoPlayer:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self refresh];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refresh {
    
    [super refresh];
    
    __weak GameViewController *weakSelf = self;
    [_gameModel refresh:^(BOOL reload) {
        [weakSelf.gameView reloadData];
        [weakSelf.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Table View Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_gameModel numberOfSections];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_gameModel numberOfRowsInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [GameHeader height];
    }
    
    else {
        
        return [GameDetailHeader height];
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [GameHeader height];
    }
    
    else {
        
        return [GameDetailHeader height];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [RefreshTableViewCell height];
    }
    
    else {
        
        if ([_gameModel hasNoEventsAtIndex:indexPath]) {
            
            return [NoDataTableViewCell height];
        }
        
        else {
            
            return UITableViewAutomaticDimension;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [RefreshTableViewCell height];
    }
    
    else {
        return [GameDetailCell height];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        RefreshTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REFRESH_CELL_REUSE_IDENTIFIER];
        
        return cell;
    }
    
    else {
        
        if ([_gameModel hasNoEventsAtIndex:indexPath]) {
            
            NoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NO_DATA_CELL_REUSE_IDENTIFIER];
            
            cell.textLabel.text = [_gameModel getNoDataText];
            
            return cell;
        }
        
        else {
            
            GameDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:GAME_DETAIL_CELL_REUSE_IDENTIFIER];
            
            [cell setEvent:[_gameModel getEventAtIndex:indexPath]];
            
            return cell;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        GameHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:GAME_HEADER_REUSE_IDENTIFIER];
        
        [header setGame:_gameModel];
        
        [header.sectionControl removeTarget:self action:@selector(tabSwitched:) forControlEvents:UIControlEventValueChanged];
        [header.sectionControl addTarget:self action:@selector(tabSwitched:) forControlEvents:UIControlEventValueChanged];
        [header.sectionControl setSelectedSegmentIndex:_gameModel.sectionIndex];
        
        [header.videoButton removeTarget:self action:@selector(videoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [header.videoButton addTarget:self action:@selector(videoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        return header;
    }
    
    else {
        
        GameDetailHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:GAME_DETAIL_HEADER_REUSE_IDENTIFIER];
        
        [header setPeriod:[_gameModel getPeriodAtIndex:section]];
        
        return header;
    }
}

#pragma header view methods
-(void)tabSwitched:(id)sender {
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    if (segmentedControl.selectedSegmentIndex != _gameModel.sectionIndex) {
        
        _gameModel.sectionIndex = segmentedControl.selectedSegmentIndex;
        [_gameView reloadData];
    }
}

-(void)videoButtonTapped:(id)sender {
    
    NSURL *videoURL = [[_gameModel.gameObject videoLinks] firstObject];
    
    AVPlayerViewController *playerController = [VideoPlayerViewController playerWithUrl:videoURL];
    [self.navigationController presentViewController:playerController animated:YES completion:nil];
}

#pragma refresh data

-(void)reloadData:(id)sender {
    __weak GameViewController *weakSelf = self;
    [APIRequestHandler getPlayoffs:^(id responseObject, NSError *error, BOOL hasNewData) {
        [weakSelf.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }];
}

-(void)dismissVideoPlayer:(NSNotification *)notification {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

@end
