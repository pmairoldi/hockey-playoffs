//
//  APIRequestHandler.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-02.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;

@interface APIRequestHandler : NSObject

+(instancetype)sharedHandler;

+(void)getPlayoffs:(void(^)(id responseObject, NSError *error, BOOL hasNewData))completion;

-(void)startSyncTimer;
-(void)stopSyncTimer;

@end
