//
//  NoContentTableView.h
//  HockeyPlayoffs
//
//  Created by Pierre-Marc Airoldi on 2015-04-14.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoContentTableView : UITableView

@property (nonatomic) NSString *noContentText;
@property (nonatomic) BOOL hasContent;

@end
