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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kUpdatePlayoffs object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdatePlayoffs object:nil];
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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return SHOULD_ROTATE(toInterfaceOrientation);
}

-(void)refresh {
    
}

@end
