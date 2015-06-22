//
//  VideoPlayerViewController.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-30.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "CRToast.h"
#import "Animations.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissedPlayer:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
  
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(BOOL)shouldAutorotate {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return !UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

+(void)showVideo:(NSURL *)url inController:(UIViewController *)controller {
    
    if (url != nil && [url isKindOfClass:[NSURL class]] && [AFNetworkReachabilityManager sharedManager].reachable) {
    
//        [CRToastManager preventNotifications:YES];

        VideoPlayerViewController *mpMoviePlayerController = [[VideoPlayerViewController alloc] initWithContentURL:url];
        
        [controller presentMoviePlayerViewControllerAnimated:mpMoviePlayerController];
    }
    
    else {
        
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            
            [VideoPlayerViewController showNotificationWithTitle:NSLocalizedString(@"error.video.title", nil)];
        }
        
        else {
            [VideoPlayerViewController showNotificationWithTitle:NSLocalizedString(@"offline", nil)];
        }
    }
}

-(void)dismissedPlayer:(NSNotification *)notification {
    
//    [CRToastManager preventNotifications:NO];
}

+(void)showNotificationWithTitle:(NSString *)title {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *options = @{
                                  kCRToastTextKey : title,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastNotificationPresentationTypeKey: @(CRToastPresentationTypeCover),
                                  kCRToastNotificationTypeKey : @(CRToastTypeStatusBar),
                                  kCRToastTimeIntervalKey : @(kAnimationDuration),
                                  kCRToastStatusBarStyleKey : @([[UIApplication sharedApplication] statusBarStyle]),
                                  kCRToastAllowDuplicatesKey : @(NO)
                                  };
        
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
    });
}

@end
