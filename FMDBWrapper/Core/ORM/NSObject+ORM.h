//
//  NSObject+ORM.h
//  FMDBWrapper
//
//  Created by sfpay on 15/3/17.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLCondition.h"

@interface NSObject (ORM)

#pragma mark 添加
- (void)asyncSaveWithSuccessCompletion:(void (^)(void)) success
                        FailCompletion:(void (^)(void)) fail;

#pragma mark - 删除
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
