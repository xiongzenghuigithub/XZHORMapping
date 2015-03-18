//
//  ObjectRelationShip.m
//  FMDBWrapper
//
//  Created by sfpay on 15/3/18.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "ObjectRelationShip.h"

@implementation ObjectRelationShip

+ (instancetype)instance {
    return [[ObjectRelationShip alloc] init];
}

+ (ObjectRelationShip *)oneToOneRelationShipWithOne:(Class)cls1 One:(Class)cls2 {
    ObjectRelationShip *ship = [ObjectRelationShip instance];
    ship.type = ObjectRelationShipOneToOne;
    ship.cls1 = cls1;
    ship.cls2 = cls2;
    return ship;
}

+ (ObjectRelationShip *)oneToManyRelationShipWithOne:(Class)cls1 Many:(Class)cls2{
    ObjectRelationShip *ship = [ObjectRelationShip instance];
    ship.type = ObjectRelationShipOneToManay;
    ship.cls1 = cls1;
    ship.cls2 = cls2;
    return ship;
}

+ (ObjectRelationShip *)manyToManyRelationShipWithMany:(Class)cls1 Many:(Class)cls2 {
    ObjectRelationShip *ship = [ObjectRelationShip instance];
    ship.type = ObjectRelationShipManyToMany;
    ship.cls1 = cls1;
    ship.cls2 = cls2;
    return ship;
}

@end
