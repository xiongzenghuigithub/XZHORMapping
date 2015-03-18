//
//  FMDatabase+ORM.h
//  FMDBWrapper
//
//  Created by sfpay on 15/3/18.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "FMDatabaseQueue.h"

@interface FMDatabaseQueue (ORM)

/* 在沙盒缓存目录创建DB文件 */
+ (FMDatabaseQueue *)queueForCachePathName:(NSString *) fileName;

@end

@interface FMDatabaseQueue (Singleton)

+ (instancetype)sharedDatabaseQueueWithPathName:(NSString *) fileName;

@end