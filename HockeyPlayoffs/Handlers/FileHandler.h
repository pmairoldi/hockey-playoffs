//
//  FileHandler.h
//  Hockey Playoffs
//
//  Created by Pierre-Marc Airoldi on 2014-04-02.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

@import Foundation;

@interface FileHandler : NSObject

+(NSString *)getBundlePathForFile:(NSString *)filename;
+(NSString *)getDocumentsDirectoryPathForFile:(NSString *)filename;
+(NSString *)getLibraryDirectoryPathForFile:(NSString *)filename;

@end
