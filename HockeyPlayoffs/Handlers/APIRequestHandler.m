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
#import "Animations.h"
#import "Queues.h"
#import "HockeyPlayoffs-Swift.h"

#define SYNCHRONIZE_REFRESH_TIME 30ull
#define SYNCHRONIZE_REFRESH_TIME_LEEWAY 30ull

@interface APIRequestHandler ()

@property NSURLSession *session;
@property NSURL *baseURL;
@property dispatch_source_t synchronizeTimer;

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
            self.queue = SYNCHRONIZE_QUEUE;
        });

        NSString *baseUrl = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"API_BASE_URL"];
        if (baseUrl == nil) {
            [NSException raise:@"InitNotImplemented" format:@"no API_BASE_URL set"];
        }

        _baseURL = [NSURL URLWithString:baseUrl];

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForResource = 20;

        _session = [NSURLSession sessionWithConfiguration:configuration];
    }

    return self;
}

+(NSURLSessionDataTask *)sendRequestToAPI:(NSString *)endpoint withData:(NSDictionary *)data completion:(void(^)(id responseObject, NSError *error, BOOL hasNewData))completion {

    APIRequestHandler *handler = [self sharedHandler];
    NSURL *url = [NSURL URLWithString:endpoint relativeToURL:handler.baseURL];

    if (data != nil) {
        NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        NSMutableArray *queryItems = [NSMutableArray array];
        for (NSString *key in data) {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:[data[key] description]]];
        }
        components.queryItems = queryItems;
        url = components.URL;
    }

    NSURLSessionDataTask *task = [handler.session dataTaskWithURL:url completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error) {

        if (error != nil) {
            if (completion != nil) {
                completion(nil, error, NO);
            }
            return;
        }

        NSError *jsonError = nil;
        id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];

        if (jsonError != nil) {
            if (completion != nil) {
                completion(nil, jsonError, NO);
            }
            return;
        }

        if (completion != nil) {
            completion(responseObject, nil, YES);
        }
    }];

    [task resume];
    return task;
}

+(NSURLSessionDataTask *) _getPlayoffs:(void(^)(id responseObject, NSError *error, BOOL hasNewData))completion {
    return [[self class] sendRequestToAPI:kPlayoffEndpoint withData:nil completion:^(id responseObject, NSError *error, BOOL hasNewData) {
        
        if (error != nil) {
            
            [ToastHandler showError:error];
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
}

+(void)getPlayoffs:(void(^)(id responseObject, NSError *error, BOOL hasNewData))completion {
    dispatch_async([[[self class] sharedHandler] queue], ^{
        [[self class] _getPlayoffs: completion];
    });
}

+(NSURLSessionDataTask *)backgroundRefresh:(void(^)(id responseObject, NSError *error, BOOL hasNewData))completion {
    return [[self class] _getPlayoffs: completion];
}

-(void)startSyncTimer {
    
    _synchronizeTimer = CreateDispatchTimer(SYNCHRONIZE_REFRESH_TIME * NSEC_PER_SEC, SYNCHRONIZE_REFRESH_TIME_LEEWAY * NSEC_PER_SEC, _queue, ^{
        
        [[self class] getPlayoffs:nil];
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

@end
