//
//  Person.m
//  FMDBWrapper
//
//  Created by sfpay on 15/3/17.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "Person.h"

@implementation Person


+ (NSString *)tableName {
    return @"personTest";
}

+ (NSString *)primaryKey {
    return @"pid";
}

///* 指出需要自定义表字段类型的属性名 */
//+ (NSDictionary *)propertyMapping {
//    return @{
//                @"pid" : @"id",
//            };
//}

@end
