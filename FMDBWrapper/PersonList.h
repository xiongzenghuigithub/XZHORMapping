//
//  PersonList.h
//  FMDBWrapper
//
//  Created by sfpay on 15/3/17.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORMBaseModel.h"
#import "Person.h"

@interface PersonList : ORMBaseModel

@property (copy, nonatomic) NSString *personListId;
@property (nonatomic, strong) NSArray *personList;

@end
