//
//  DBOperation.m
//  FMDBWrapper
//
//  Created by sfpay on 15/3/18.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "DBOperation.h"

@interface DBOperation ()

@property(strong, nonatomic) NSRecursiveLock *threadLock;

@end

@implementation DBOperation

+ (instancetype)sharedDBOperationWithDBName:(NSString *) dbName {
    static DBOperation *op = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        op = [[DBOperation alloc] initWithDBName:dbName];
    });
    return op;
}

- (void)dealloc {
    self.dbQueue = nil;
    self.threadLock = nil;
}

- (instancetype)initWithDBName:(NSString *) dbName {
    self = [super init];
    if (self) {
        self.dbPath = [DBOperation appendingPathAtCacheDir:dbName];
        [self initDBQueue];
        [self initLock];
    }
    return self;
}

#pragma marh - private methodds

- (void)initDBQueue {
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
}

- (void)initLock {
    self.threadLock = [[NSRecursiveLock alloc] init];
}

+ (NSString *)cacheDir {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)appendingPathAtCacheDir:(NSString *) fileName {
    return [[self cacheDir] stringByAppendingPathComponent:fileName];
}

+ (void)queueForCachePathName:(NSString *)fileName {
    [FMDatabaseQueue databaseQueueWithPath:[self appendingPathAtCacheDir:fileName]];
}

- (void)lock {
    [self.threadLock lock];
}

- (void)unLock {
    [self.threadLock unlock];
}

@end
