//
//  SeriesViewController.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-04.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "SeriesViewController.h"
#import "SeriesModel.h"
#import "SeriesView.h"
#import "GameCell.h"
#import "SeriesHeader.h"
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

@interface SeriesViewController ()

@property UIRefreshControl *refreshControl;
@property SeriesView *seriesView;
@property SeriesModel *seriesModel;

@end

@implementation SeriesViewController

- (id)initWithSeries:(SeriesObject *)series {
    
    self = [super init];
    
    if (self) {
        
        _seriesModel = [SeriesModel initWithSeries:series];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [Colors backgroundColor];
    
    self.title = [_seriesModel getControllerTitle];
    
    _seriesView = [[SeriesView alloc] initWithFrame:self.view.frame];
    _seriesView.delegate = self;
    _seriesView.dataSource = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor whiteColor];
    
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    
    [_seriesView addSubview:_refreshControl];
    
    [self.view addSubview:_seriesView];
    
    _seriesView.hasContent = _seriesModel.hasData;
    
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
    
    __weak SeriesViewController *weakSelf = self;
    [_seriesModel refresh:^(BOOL reload) {
        weakSelf.seriesView.hasContent = weakSelf.seriesModel.hasData;
        [weakSelf.seriesView reloadData];
        [weakSelf.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Table View Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_seriesModel numberOfSections];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_seriesModel numberOfRowsInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0 && _seriesModel.hasTeams) {
        
        return [SeriesHeader height];
    }
    
    else {
        return 0.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    if (section == 0 && _seriesModel.hasTeams) {
        
        return [SeriesHeader height];
    }
    
    else {
        return 0.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [_seriesModel heightForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [_seriesModel estimatedHeightForRowAtIndexPath:indexPath];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && _seriesModel.isRefreshing) {
        
        RefreshTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REFRESH_CELL_REUSE_IDENTIFIER];
        
        return cell;
    }
    
    else if (indexPath.section == 0 && !_seriesModel.isRefreshing) {
        
        NoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NO_DATA_CELL_REUSE_IDENTIFIER];
        
        cell.textLabel.text = NSLocalizedString(@"series.nodata", nil);
        
        return cell;
    }
    
    else {
        
        GameCell *cell = [tableView dequeueReusableCellWithIdentifier:GAME_CELL_REUSE_IDENTIFIER];
        cell.videoButton.tag = indexPath.row;
        [cell setGame:[_seriesModel getGameAtIndex:indexPath]];
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

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {

    UITableViewHeaderFooterView *headerFooter = (UITableViewHeaderFooterView *)view;
    
    headerFooter.contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, [self tableView:tableView heightForHeaderInSection:section]);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0 && _seriesModel.hasTeams) {
        
        SeriesHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SERIES_HEADER_REUSE_IDENTIFIER];
        
        [header setSeries:_seriesModel];
        
        return header;
    }
    
    else {
        return nil;
    }
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
    
    GameObject *game = [_seriesModel getGameAtIndex:indexPath];
    
    GameViewController *controller = [[GameViewController alloc] initWithGame:game];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)videoButtonTapped:(VideoButton *)sender {
    
    if ([sender tag] == NSNotFound || [sender tag] >= [_seriesModel getGames].count) {
        return;
    }
    
    [self expandAtIndex:(int)[sender tag]];
}

-(void)expandAtIndex:(int)index {
    
    GameObject *game = [_seriesModel getGameAtIndex:[NSIndexPath indexPathForRow:index inSection:0]];
    
    NSURL *videoURL = [[game videoLinks] firstObject];
        
    AVPlayerViewController *playerController = [VideoPlayerViewController playerWithUrl:videoURL];
    [self.navigationController presentViewController:playerController animated:YES completion:nil];
}

-(void)homeHighlightsTapped:(UIButton *)sender {
    
    if ([sender tag] == NSNotFound || [sender tag] >= [_seriesModel getGames].count) {
        return;
    }
    
    GameObject *game = [_seriesModel getGameAtIndex:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    
    NSURL *videoURL = [NSURL URLWithString:game.homeHighlight];
   
    AVPlayerViewController *playerController = [VideoPlayerViewController playerWithUrl:videoURL];
    [self.navigationController presentViewController:playerController animated:YES completion:nil];
}

-(void)awayHighlightsTapped:(UIButton *)sender {
    
    if ([sender tag] == NSNotFound || [sender tag] >= [_seriesModel getGames].count) {
        return;
    }
    
    GameObject *game = [_seriesModel getGameAtIndex:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    
    NSURL *videoURL = [NSURL URLWithString:game.awayHighlight];
    
    AVPlayerViewController *playerController = [VideoPlayerViewController playerWithUrl:videoURL];
    [self.navigationController presentViewController:playerController animated:YES completion:nil];
}

#pragma refresh data

-(void)reloadData:(id)sender {
    __weak SeriesViewController *weakSelf = self;
    [APIRequestHandler getPlayoffsWithData:nil completion:^(id responseObject, NSError *error, BOOL hasNewData) {
        [weakSelf.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    }];
}

-(void)dismissVideoPlayer:(NSNotification *)notification {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

@end
