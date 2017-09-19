//
//  FileHandler.m
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-02.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

#import "FileHandler.h"

@implementation FileHandler

+(NSString *)getBundlePathForFile:(NSString *)filename {
    
    NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];
    
    return defaultDBPath;
}

+(NSString *)getDocumentsDirectoryPathForFile:(NSString *)filename {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    return writableDBPath;
}

+(NSString *)getLibraryDirectoryPathForFile:(NSString *)filename {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    return writableDBPath;
}

@end
