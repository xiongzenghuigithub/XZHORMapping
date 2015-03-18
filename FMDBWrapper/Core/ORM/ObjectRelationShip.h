//
//  ObjectRelationShip.h
//  FMDBWrapper
//
//  Created by sfpay on 15/3/18.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ObjectRelationShipType) {
    ObjectRelationShipOneToOne = 1,
    ObjectRelationShipOneToManay ,
    ObjectRelationShipManyToMany ,
};

@interface ObjectRelationShip : NSObject

@property (assign, nonatomic) ObjectRelationShipType type;

@property (strong, nonatomic) Class cls1;
@property (strong, nonatomic) Class cls2;

/* 1:1 */
+ (ObjectRelationShip *)oneToOneRelationShipWithOne:(Class) cls1
                                                One:(Class) cls2;

/* 1:n */
+ (ObjectRelationShip *)oneToManyRelationShipWithOne:(Class) cls1
                                                Many:(Class) cls2;

/* n:n */
+ (ObjectRelationShip *)manyToManyRelationShipWithMany:(Class) cls1
                                                  Many:(Class) cls2;

@end
