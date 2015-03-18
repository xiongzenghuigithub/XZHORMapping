//
//  DBOperation.h
//  FMDBWrapper
//
//  Created by sfpay on 15/3/18.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabaseQueue.h>

@interface DBOperation : NSObject


@property (strong, nonatomic) FMDatabaseQueue *dbQueue;
@property (strong, nonatomic) NSString *dbPath;
@property (strong, nonatomic) NSMutableArray *createdTables;

/* 在沙盒缓存目录创建DB文件 */
+ (instancetype)sharedDBOperationWithDBName:(NSString *) dbName;

- (void)lock;
- (void)unLock;

@end
