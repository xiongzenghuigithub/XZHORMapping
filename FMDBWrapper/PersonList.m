//
//  PersonList.m
//  FMDBWrapper
//
//  Created by sfpay on 15/3/17.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "PersonList.h"


@implementation PersonList

+ (NSArray *)relationShips {
    return @[[ObjectRelationShip oneToManyRelationShipWithOne:[self class]
                                                         Many:[Person class]]];
}

+ (NSString *)primaryKey {
    return @"personListId";
}

@end
