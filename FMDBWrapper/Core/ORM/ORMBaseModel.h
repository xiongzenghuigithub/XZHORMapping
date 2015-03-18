
//
//  ORMBaseModel.h
//  FMDBWrapper
//
//  Created by sfpay on 15/3/18.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLCondition.h"
#import "ObjectRelationShip.h"

@interface ORMBaseModel : NSObject

@property (copy, nonatomic) NSString *createDate;
@property (copy, nonatomic) NSString *updateDate;

#pragma mark - 与数据库映射关系

/* 表名 */
+ (NSString *)tableName;

/* 主键 */
+(NSString*)primaryKey;

/* 联合主键 */
+(NSArray*)primaryKeyUnionArray;

/* 自定义表字段类型的属性名 【属性名 : 表字段名】 */
+(NSDictionary *)propertyMapping;

/* 指出对象的关系 */
+ (NSArray *)relationShips;

#pragma mark - DB Operation

#pragma mark 添加
- (void)asyncSaveWithSuccessCompletion:(void (^)(void)) success
                        FailCompletion:(void (^)(void)) fail;

#pragma mark 删除
- (void)asyncRemoveWithSuccessCompletion:(void (^)(void)) success
                          FailCompletion:(void (^)(void)) fail;

- (void)asyncUpdateWithSuccessCompletion:(void (^)(void)) success
                          FailCompletion:(void (^)(void)) fail;

/* 查询所有当前实体对象的记录 */
- (void)asyncQueryWithSuccessCompletion:(void (^)(NSArray __autoreleasing*objects)) success
                         FailCompletion:(void (^)(void)) fail
                               PageSize:(NSInteger) pageSize
                             StartIndex:(NSInteger) startIndex;

/* 按条件查询所有当前实体对象的记录 */
- (void)asyncQueryWithSearchCondition:(NSArray *) conditions
                    SuccessCompletion:(void (^)(NSArray __autoreleasing*objects)) success
                       FailCompletion:(void (^)(void)) fail
                             PageSize:(NSInteger) pageSize
                           StartIndex:(NSInteger) startIndex;

@end
