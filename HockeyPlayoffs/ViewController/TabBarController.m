//
//  TabBarController.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2/23/2014.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "TabBarController.h"
#import "BracketViewController.h"
#import "RecentGamesViewController.h"
#import "NewsViewController.h"
#import "StatisticsViewController.h"
#import "TeamsViewController.h"
#import "SettingsViewController.h"
#import "Colors.h"
#import "Rotation.h"
#import "Images.h"
#import "BaseUINavigationController.h"

@interface TabBarController ()

@property BracketViewController *bracketViewController;
@property RecentGamesViewController *recentGamesViewController;
@property NewsViewController *newsViewController;
@property StatisticsViewController *statsisticsViewController;
@property TeamsViewController *teamsViewController;
@property SettingsViewController *settingsViewController;

@end

@implementation TabBarController

-(id)init {
    
    self = [super init];
    
    if (self) {
        // Custom initialization
        
        self.delegate = self;
        
        if (@available(iOS 13.0, *)) {    
            self.tabBar.standardAppearance.backgroundColor = [Colors navigationBarColor];
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance;
        } else {
            self.tabBar.barTintColor = [Colors navigationBarColor];
        }
        
        _bracketViewController = [[BracketViewController alloc] init];
        _bracketViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:_bracketViewController.title image:[UIImage imageNamed:BRACKET_TAB_ICON] selectedImage:nil];

        _recentGamesViewController = [[RecentGamesViewController alloc] init];
        _recentGamesViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:_recentGamesViewController.title image:[UIImage imageNamed:RECENT_TAB_ICON] selectedImage:nil];

        [self setViewControllers:@[[self addControllerToNavigationController:_bracketViewController navbarClass:nil], [self addControllerToNavigationController:_recentGamesViewController navbarClass:nil]]];
    }
    
    return self;
}

-(BaseUINavigationController *)addControllerToNavigationController:(UIViewController *)rootController navbarClass:(Class)navbarClass {
    
    BaseUINavigationController *navigationController = [[BaseUINavigationController alloc] initWithNavigationBarClass:navbarClass toolbarClass:nil];
    [navigationController pushViewController:rootController animated:NO];
    
    if (@available(iOS 13.0, *)) {
        navigationController.navigationBar.standardAppearance.backgroundColor = [Colors navigationBarColor];
        navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance;
    } else {
        navigationController.navigationBar.barTintColor = [Colors navigationBarColor];
    }
    return navigationController;
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return YES;
}

#ifdef __IPHONE_9_0
-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return SUPPORTED_ORIENTATIONS;
}
#else
-(NSUInteger)supportedInterfaceOrientations {
    return SUPPORTED_ORIENTATIONS;
}
#endif

@end
