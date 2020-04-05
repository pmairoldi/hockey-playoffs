//
//  GameViewController.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-03-18.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import UIKit;
#import "BaseViewController.h"

@class GameObject;

@interface GameViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

-(id)initWithGame:(GameObject *)game;

@end
