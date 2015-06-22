//
//  NSObject+PMDescription.m
//  HockeyPlayoffs
//
//  Created by Pierre-Marc Airoldi on 2015-04-14.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "NSObject+PMDescription.h"
#import <objc/runtime.h>

@implementation NSObject (PMDescription)

-(NSString *)pm_description {
    
    NSMutableDictionary *descriptionDictionary = [NSMutableDictionary new];
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; ++i) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        id value = [self valueForKey:propertyName];
        
        [descriptionDictionary setValue:value forKey:propertyName];
    }
    
    free(properties);
    
    return [NSString stringWithFormat:@"%@ : %@", NSStringFromClass([self class]), [[[descriptionDictionary description] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@" "]];
}

@end

