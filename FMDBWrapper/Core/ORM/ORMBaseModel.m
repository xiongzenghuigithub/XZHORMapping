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
            
            //表已经存在 , 按照当前Class类型，修正数据库表
//            NSString *sql = [[strongSelf class] fixTableSQL];
            
        } else {
            
            //表不存在 , 按照当前Class类型，创建数据库表
            
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
                        
                        //先创建1 的表
                        NSArray *columns = [[strongSelf propertyDictionary] allKeys];
                        NSMutableArray *insertColumns = [NSMutableArray array]; //保存去除数组属性的字段
                        NSMutableArray *constraints = [NSMutableArray array];
                        if ([[strongSelf class] primaryKey]) {
                            NSString *constraint = [NSString stringWithFormat:@"PRIMARY KEY (%@)", [[strongSelf class] primaryKey]];
                            [constraints addObject:constraint];
                        }
                        
                        for (NSString *keyPath in [[strongSelf propertyDictionary] allKeys]) {
                            id obj = [[strongSelf objectDictionary] objectForKey:keyPath];
                            if (![obj isKindOfClass:[NSArray class]]) {
                                [insertColumns addObject:keyPath];
                            }
                        }
                        
                        [db createTableWithName:[[strongSelf class] tableName]
                                        columns:insertColumns
                                    constraints:constraints
                                          error:nil];
                        
                        //再创建n 的表
                        NSString * foreigKey = [one primaryKey];

                        for (NSString *keyPath in [[strongSelf propertyDictionary] allKeys]) {  //属性字符串
                            if ([strongSelf respondsToSelector:NSSelectorFromString(keyPath)]) {    //属性字符串转换 SEL
                                id obj = [strongSelf performSelector:NSSelectorFromString(keyPath) withObject:nil]; //动态执行SEL
                                if ([obj isKindOfClass:[NSArray class]]) {
                                    NSArray *array = (NSArray *)obj;
                                    id perObj = [array lastObject];
                                    if ([perObj isKindOfClass:many]) {
                                        //1. 字段
                                        NSMutableArray *columns = [[[perObj propertyDictionary] allKeys] mutableCopy];
                                        [columns addObject:[[strongSelf class] primaryKey]];
                                        //2. 主键、外键 约束
                                        NSMutableArray *constraints = [NSMutableArray array];
                                        if ([[perObj class] primaryKey]) {
                                            NSString *primaryKeyConstraint = [NSString stringWithFormat:@"PRIMARY KEY (%@)", [[perObj class] primaryKey]];
                                            NSString *foreignkeyConstraint = [NSString stringWithFormat:@"FOREIGN KEY(%@) REFERENCES %@(%@)", foreigKey, [[strongSelf class] tableName], [[strongSelf class] primaryKey]];
                                            [constraints addObject:primaryKeyConstraint];
                                            [constraints addObject:foreignkeyConstraint];
                                        }
                                        
                                        //3. 建表
                                        [db createTableWithName:[[perObj class] tableName]
                                                        columns:columns
                                                    constraints:constraints
                                                          error:nil];
                                    }
                                }
                            }
                        }
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
            if ([[[strongSelf class] relationShips] count] < 1) {
                
                NSArray *columns = [[strongSelf propertyDictionary] allKeys];
                NSMutableArray *constraints = [NSMutableArray array];
                if ([[strongSelf class] primaryKey]) {
                    [constraints addObject:[NSString stringWithFormat:@"PRIMARY KEY (%@)" , [[strongSelf class] primaryKey]]];
                    
                    error = nil;
                    [db createTableWithName:[[strongSelf class] tableName] columns:columns constraints:constraints error:&error];
                }
                
                NSMutableArray *values = [NSMutableArray array];
                for (NSString *keyPath in [[strongSelf propertyDictionary] allKeys]) {
                    [values addObject:[[strongSelf objectDictionary] objectForKey:keyPath]];
                }
                
                error = nil;
                [db insertInto:[[strongSelf class] tableName] columns:columns values:@[values] error:&error];
                
            } else { // 有关联对象的数据插入
                //1. 先插1方表数据
                NSArray *columns = [[strongSelf propertyDictionary] allKeys];
                NSMutableArray *insertColumns = [NSMutableArray array];
                NSMutableArray *values = [NSMutableArray array];
                NSMutableArray *manyArray = [NSMutableArray array];
                for (NSString *keyPath in [[strongSelf propertyDictionary] allKeys]) {
                    id obj = [strongSelf performSelector:NSSelectorFromString(keyPath) withObject:nil];
                    if (![obj isKindOfClass:[NSArray class]]) {
                        [values addObject:obj];
                        [insertColumns addObject:keyPath];
                    }else {
                        [manyArray addObject:obj];
                    }
                }
                
                [db insertInto:[[strongSelf class] tableName] columns:insertColumns values:@[values] error:nil];
                
                //2. 再插n方表数据
//                for (<#type *object#> in <#collection#>) {
//                    <#statements#>
//                }
            }
            
        }
        
    }];
}


@end
