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
#import "Colours.h"
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
    self.view.backgroundColor = BACKGROUND_COLOUR;
    
    _gameView = [[GameView alloc] initWithFrame:self.view.frame];
    _gameView.delegate = self;
    _gameView.dataSource = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor whiteColor];
    
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    
    [_gameView addSubview:_refreshControl];
    
    [self.view addSubview:_gameView];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self refresh];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

-(void)refresh {
    
    [super refresh];
    
    [_gameModel refresh:^(BOOL reload) {
        
        [_gameView reloadData];
        
        [_refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
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
            
            return [GameDetailCell height];
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
            
            if(indexPath.row == 0){
                cell.seperatorView.hidden = YES;
            }
            
            else {
                cell.seperatorView.hidden = NO;
            }
            
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.contentView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *headerFooter = (UITableViewHeaderFooterView *)view;
    
    headerFooter.contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, [self tableView:tableView heightForHeaderInSection:section]);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        GameHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:GAME_HEADER_REUSE_IDENTIFIER];
        
        [header setGame:_gameModel];
        
        [header.sectionControl addTarget:self action:@selector(tabSwitched:) forControlEvents:UIControlEventValueChanged];
        [header.sectionControl setSelectedSegmentIndex:_gameModel.sectionIndex];
        
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
    
    [VideoPlayerViewController showVideo:videoURL inController:self.navigationController];
}

#pragma refresh data

-(void)reloadData:(id)sender {
    
    [APIRequestHandler getPlayoffsWithData:nil completion:^(id responseObject, NSError *error, BOOL hasNewData) {
        
        [_refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }];
}

@end
