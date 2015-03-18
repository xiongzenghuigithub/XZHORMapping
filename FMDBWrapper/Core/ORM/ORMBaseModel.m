//
//  ORMBaseModel.m
//  FMDBWrapper
//
//  Created by sfpay on 15/3/18.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "ORMBaseModel.h"

#import "DBOperation.h"
#import "NSObject+ObjectMap.h"
#import "FMDatabaseQueue+ORM.h"
#import "FMDatabase+LocalDBHelper.h"
#import <FMDB/FMDatabaseAdditions.h>


static NSString *DatabaseName = @"LocalData.db";

@implementation ORMBaseModel

- (NSString *)createDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

- (NSString *)updateDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSString *)tableName {
    return [self nameOfClass];
}

+ (NSString *)primaryKey {
    return nil;
}

+ (NSArray *)primaryKeyUnionArray {
    return nil;
}

+ (NSDictionary *)propertyMapping {
    return nil;
}

+ (NSArray *)relationShips {
    return nil;
}

+ (NSString *)fixTableSQL {
    
    return @"";
}

- (void)asyncSaveWithSuccessCompletion:(void (^)(void))success FailCompletion:(void (^)(void))fail {
    
    
    DBOperation *op = [DBOperation sharedDBOperationWithDBName:DatabaseName];
    
    __weak __typeof(self) weakSelf = self;
    [[op dbQueue] inDatabase:^(FMDatabase *db) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSError *error = nil;
        
        NSString *tName = [[strongSelf class] tableName];
        
        if ([db tableExists:tName]) {
            
            //表已经存在
            //1. 按照当前Class类型，修正数据库表
//            NSString *sql = [[strongSelf class] fixTableSQL];
            
            //2. 插入数据
            
        } else {
            
            //表不存在
            //1. 按照当前Class类型，创建数据库表
            
            //1.1 有关联关系
            for (ObjectRelationShip *ship in [[strongSelf class] relationShips]) {
                
                switch ([ship type]) {
                    case ObjectRelationShipOneToOne: {
                        //1:1
                    }
                        break;
                        
                    case ObjectRelationShipOneToManay: {
                        //1:n
                        Class one = [ship cls1];
                        Class many = [ship cls2];
                        
                    }
                        break;
                    case ObjectRelationShipManyToMany: {
                        //n:n
                    }
                        break;
                    default: {
                        //没有关联
                        
                    }
                        break;
                }

            }
            
            //1.2 没有关联关系
            NSArray *columns = [[strongSelf propertyDictionary] allKeys];
            NSMutableArray *constraints = [NSMutableArray array];
            if ([[strongSelf class] primaryKey]) {
                [constraints addObject:[NSString stringWithFormat:@"PRIMARY KEY (%@)" , [[strongSelf class] primaryKey]]];
                
                error = nil;
                [db createTableWithName:[[strongSelf class] tableName] columns:columns constraints:constraints error:&error];
            }
            
            //2 插入数据
            NSMutableArray *values = [NSMutableArray array];
            for (NSString *keyPath in columns) {
                [values addObject:[[strongSelf objectDictionary] objectForKey:keyPath] ];
            }
            
            error = nil;
            [db insertInto:[[strongSelf class] tableName] columns:columns values:@[values] error:&error];
            
        }
        
    }];
}


@end
