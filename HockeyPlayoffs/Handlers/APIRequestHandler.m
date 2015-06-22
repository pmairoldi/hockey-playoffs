//
//  APIRequestHandler.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-02.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "APIRequestHandler.h"
#import "DatabaseHandler.h"
#import "APIIdentifiers.h"
#import "CRToast.h"
#import "Animations.h"
#import "Queues.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <Keys/HockeyPlayoffsKeys.h>

#define SYNCHRONIZE_REFRESH_TIME 10ull
#define SYNCHRONIZE_REFRESH_TIME_LEEWAY 1ull

@interface APIRequestHandler ()

@property AFHTTPSessionManager *manager;
@property dispatch_source_t synchronizeTimer;
@property dispatch_queue_t synchronizeQueue;

@end

@implementation APIRequestHandler

+(instancetype)sharedHandler {
    
    static APIRequestHandler *sharedHandler = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedHandler = [[self alloc] init];
    });
    
    return sharedHandler;
}

-(id)init {
    
    self = [super init];
    
    if (self) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            _synchronizeQueue = SYNCHRONIZE_QUEUE;
        });
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForResource = 20;
        
        HockeyPlayoffsKeys *keys = [HockeyPlayoffsKeys new];
        
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:keys.hockeyAPIPath] sessionConfiguration:configuration];
        [_manager setCompletionQueue:_synchronizeQueue];
    }
    
    return self;
}

+(void)sendRequestToAPI:(NSString *)endpoint withData:(NSDictionary *)data completion:(void(^)(id responseObject, NSError *error, BOOL hasNewData))completion {
    
    AFHTTPSessionManager *manager = [[self sharedHandler] manager];
    
    [manager GET:endpoint parameters:data success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (completion != nil) {
            completion(responseObject, nil, YES);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (completion != nil) {
            completion(nil, error, NO);
        }
    }];
}

+(void)getPlayoffsWithData:(NSDictionary *)data completion:(void(^)(id responseObject, NSError *error, BOOL hasNewData))completion {
    
     dispatch_async([[[self class] sharedHandler] synchronizeQueue], ^{
        
        [[self class] sendRequestToAPI:kPlayoffEndpoint withData:data completion:^(id responseObject, NSError *error, BOOL hasNewData) {
            
            if (error != nil) {
                
                [[self class] showNotificationForError:error];
            }
            
            else {
                
                [DatabaseHandler updatePlayoffData:responseObject];
            }
            
            if (completion != nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(responseObject, error, hasNewData);
                });
            }
        }];
        
    });
}

-(void)startSyncTimer {
    
    _synchronizeTimer = CreateDispatchTimer(SYNCHRONIZE_REFRESH_TIME * NSEC_PER_SEC, SYNCHRONIZE_REFRESH_TIME_LEEWAY * NSEC_PER_SEC, _synchronizeQueue, ^{
        
        [[self class] getPlayoffsWithData:nil completion:nil];
    });
}

-(void)stopSyncTimer {
    
    if (_synchronizeTimer != nil) {
        dispatch_source_cancel(_synchronizeTimer);
    }
}

dispatch_source_t CreateDispatchTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block) {
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    
    return timer;
}

+(void)showNotificationForError:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *message;
        
        if (error != nil) {
            
            message = [error localizedDescription];
        }
        
        else {
            
            message = @"";
        }
        
        NSDictionary *options = @{
                                  kCRToastTextKey : message,
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
