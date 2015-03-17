//
//  Person.h
//  FMDBWrapper
//
//  Created by sfpay on 15/3/17.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (assign, nonatomic) NSInteger age;
@property (assign, nonatomic) BOOL isMan;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSData *data;

@end
