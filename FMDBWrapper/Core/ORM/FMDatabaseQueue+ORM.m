//
//  FMDatabase+ORM.m
//  FMDBWrapper
//
//  Created by sfpay on 15/3/18.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "FMDatabaseQueue+ORM.h"

@implementation FMDatabaseQueue (ORM)

+ (NSString *)cacheDir {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)appendingPathAtCacheDir:(NSString *) fileName {
    return [[self cacheDir] stringByAppendingPathComponent:fileName];
}

+ (FMDatabaseQueue *)queueForCachePathName:(NSString *)fileName {
    return [self databaseQueueWithPath:[self appendingPathAtCacheDir:fileName]];
}

@end

@implementation FMDatabaseQueue (Singleton)

+ (instancetype)sharedDatabaseQueueWithPathName:(NSString *)fileName {
    static FMDatabaseQueue *staticQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticQueue = [self queueForCachePathName:fileName];
    });
    return staticQueue;
}

@end