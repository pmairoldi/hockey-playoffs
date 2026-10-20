//
//  BaseViewController.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-30.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "BaseViewController.h"
#import "Rotation.h"
#import "Notifications.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)init {
    
    self = [super init];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (@available(iOS 27.1, *)) {
        [self registerForTraitChanges:UITraitCollection.systemTraitsAffectingVerticalBarEdge
                         withHandler:^(__kindof BaseViewController *controller, UITraitCollection *previousTraits) {
            [controller updateNavigationBarMinimization];
        }];
    }
    // Recalculate custom summary heights as Dynamic Type changes. Labels
    // update their fonts automatically; tables also need to remeasure rows.
    [self registerForTraitChanges:@[[UITraitPreferredContentSizeCategory class]]
                     withHandler:^(__kindof UIViewController *controller, UITraitCollection *previousTraits) {
        for (UIView *view in controller.view.subviews) {
            if ([view isKindOfClass:[UITableView class]]) {
                [(UITableView *)view reloadData];
            }
        }
    }];
}

- (void)updateNavigationBarMinimization {
    if (@available(iOS 27.1, *)) {
        UIBarMinimization *configuration = [self.navigationItem.navigationBarMinimization copy];
        // Keep Duo's navigation title pinned when controls move to a side bar.
        // Ordinary horizontal bars retain their existing system behavior.
        configuration.minimizationBehavior = self.traitCollection.verticalBarEdge == UIVerticalBarEdgeUnspecified ?
            UIBarMinimizationBehaviorAutomatic : UIBarMinimizationBehaviorNever;
        self.navigationItem.navigationBarMinimization = configuration;
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self updateNavigationBarMinimization];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kUpdatePlayoffs object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdatePlayoffs object:nil];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return SUPPORTED_ORIENTATIONS;
}

-(void)refresh {
    
}

@end
