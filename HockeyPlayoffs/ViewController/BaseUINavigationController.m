//
//  BaseUINavigationController.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-09.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "BaseUINavigationController.h"
#import "Rotation.h"

@interface BaseUINavigationController ()

@end

@implementation BaseUINavigationController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
