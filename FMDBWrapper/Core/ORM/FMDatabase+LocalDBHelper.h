//
//  FMDatabase+LocalDBHelper.h
//  FMDBWrapper
//
//  Created by sfpay on 15/3/18.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "FMDatabase.h"

@interface FMDatabase (LocalDBHelper)

/* 创建表 */
- (BOOL)createTableWithName:(NSString *)tableName
                    columns:(NSArray *)columns
                constraints:(NSArray *)constraints
                      error:(NSError **)error_p;

@end
