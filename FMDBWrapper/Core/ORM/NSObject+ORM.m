//
//  NSObject+ORM.m
//  FMDBWrapper
//
//  Created by sfpay on 15/3/17.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "NSObject+ORM.h"
#import "FMDatabaseQueue+ORM.h"
#import <FMDB/FMDatabaseAdditions.h>

@implementation NSObject (ORM)

- (NSString *)tableName {
    return NSStringFromClass([self class]);
}

- (void)asyncSaveWithSuccessCompletion:(void (^)(void))success FailCompletion:(void (^)(void))fail {
    FMDatabaseQueue *queue = [FMDatabaseQueue sharedDatabaseQueueWithPathName:@"localDB.db"];
    
    __weak __typeof(self) weakSelf = self;
    [queue inDatabase:^(FMDatabase *db) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *tName = [strongSelf tableName];
    }];
}

@end
