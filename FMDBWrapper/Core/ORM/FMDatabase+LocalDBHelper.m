//
//  FMDatabase+LocalDBHelper.m
//  FMDBWrapper
//
//  Created by sfpay on 15/3/18.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "FMDatabase+LocalDBHelper.h"

@implementation FMDatabase (LocalDBHelper)




#pragma mark - CREATE TABLE
- (BOOL)createTableWithName:(NSString *)tableName
                    columns:(NSArray *)columns
                constraints:(NSArray *)constraints
                      error:(NSError *__autoreleasing *)error_p
{
    
    NSMutableArray * createTable = [[NSMutableArray alloc] init];
    
    [createTable addObject:@"CREATE TABLE"];
    
    [createTable addObject:[FMDatabase escapeIdentifier:tableName]];
    [createTable addObject:@"("];
    
    BOOL isFirstColumn = YES;
    for (id columnDef in columns)
    {
        if (isFirstColumn == NO)
        {
            [createTable addObject:@","];
        }
        
        if ([columnDef isKindOfClass:[NSArray class]])
        {
            for (NSString * component in columnDef)
            {
                [createTable addObject:component];
            }
        }
        else if ([columnDef isKindOfClass:[NSString class]])
        {
            [createTable addObject:columnDef];
        }
        else
        {
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:[NSString stringWithFormat:@"Invalid column definition (%@): %@",
                                                   NSStringFromClass([columnDef class]),
                                                   columnDef]
                                         userInfo:nil];
        }
        
        isFirstColumn = NO;
    }
    
    // constraints
    for (NSString * constraint in constraints)
    {
        [createTable addObject:@","];
        [createTable addObject:constraint];
    }
    
    [createTable addObject:@")"];
    
    return [self executeUpdate:[createTable componentsJoinedByString:@" "]
                         error:error_p];
}

#pragma mark - insert
/* 同时可插入多条数据 【多条数据组成一个数组】 */
- (BOOL)insertInto:(NSString *)tableName
           columns:(NSArray *)columns
            values:(NSArray *)values
             error:(NSError **)error_p
{
    NSParameterAssert(columns != nil);
    NSParameterAssert(columns.count > 0);
    NSParameterAssert(tableName != nil);
    
    NSMutableArray *insertSQL = [NSMutableArray array];
    [insertSQL addObject:@"INSERT INTO"];
    [insertSQL addObject:tableName];
    
    // (字段1， 字段2， 字段3 ... )
    if (columns.count > 0) {
        [insertSQL addObject:@"("];
        
        [columns enumerateObjectsUsingBlock:^(NSString * columnName, NSUInteger idx, BOOL *stop) {
            if (idx > 0)
            {
                [insertSQL addObject:@","];
            }
            
            [insertSQL addObject:[FMDatabase escapeIdentifier:columnName]];
        }];
        
        [insertSQL addObject:@")"];
    }
    
    // values (值1，值2，值3 ... )
    NSMutableArray * flattenedValues = [[NSMutableArray alloc] initWithCapacity:(columns.count * values.count)];
    if (values.count == 0)
    {
        [insertSQL addObject:@"DEFAULT VALUES"];
    }
    else
    {
        [insertSQL addObject:@"VALUES"];
        
        NSString * argumentTuple = [FMDatabase argumentTupleOfSize:columns.count];
        
        [values enumerateObjectsUsingBlock:^(NSArray * row, NSUInteger rowIdx, BOOL *stop) {
            
            // 每一个数据项数组长度 == 插入表的总字段长度
            NSParameterAssert(row.count == columns.count);
            
            if (rowIdx > 0)
            {
                [insertSQL addObject:@","];
            }
            
            [insertSQL addObject:argumentTuple];
            [flattenedValues addObjectsFromArray:row];
        }];
    }
    
    return [self executeUpdate:[insertSQL componentsJoinedByString:@" "]
          withArgumentsInArray:flattenedValues
                         error:error_p];
}

#pragma mark - escape
+ (NSString *)escapeString:(NSString *)value {
    value = [value stringByReplacingOccurrencesOfString:@"'"
                                             withString:@"''"];
    
    return [NSString stringWithFormat:@"'%@'", value];
}

+ (NSString *)escapeIdentifier:(NSString *)value {
    value = [value stringByReplacingOccurrencesOfString:@"\""
                                             withString:@"\"\""];
    
    return [NSString stringWithFormat:@"\"%@\"", value];
}

+ (NSString *)escapeValue:(id)value {
    if (value == nil || value == [NSNull null])
    {
        return @"NULL";
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return [self escapeString:value];
    }
    else if ([value respondsToSelector:@selector(stringValue)])
    {
        return [self escapeString:[value stringValue]];
    }
    else
    {
        return [self escapeString:[value description]];
    }
    
}

/* 表字段 */
+ (NSString *)listOfColumns:(NSArray *)columnNames
{
    if (columnNames != nil)
    {
        return [columnNames componentsJoinedByString:@","];
    }
    else
    {
        return @"*";
    }
}


#pragma mark - private exexcute update
- (BOOL)executeUpdate:(NSString *)sql
                error:(NSError **)error_p
{
    return [self executeUpdate:sql
          withArgumentsInArray:@[]
                         error:error_p];
}

- (BOOL)executeUpdate:(NSString *)sql
 withArgumentsInArray:(NSArray *)arguments
                error:(NSError **)error_p
{
#if DEBUG
    if (getenv("DEBUG_SQL"))
    {
        NSLog(@"executeUpdate: %@\n%@", sql, arguments);
    }
#endif
    
    BOOL successful = [self executeUpdate:sql
                     withArgumentsInArray:arguments];
    if (NO == successful && error_p != NULL)
    {
        *error_p = self.lastError;
    }
    return successful;
}

- (BOOL)  executeUpdate:(NSString *)sql
withParameterDictionary:(NSDictionary *)arguments
                  error:(NSError **)error_p
{
#if DEBUG
    if (getenv("DEBUG_SQL"))
    {
        NSLog(@"executeUpdate: %@\n%@", sql, arguments);
    }
#endif
    
    BOOL successful = [self executeUpdate:sql
                  withParameterDictionary:arguments];
    if (NO == successful && error_p != NULL)
    {
        *error_p = self.lastError;
    }
    return successful;
}

/* (?, ?, ? ,? ) */
+ (NSString *)argumentTupleOfSize:(NSUInteger)tupleSize
{
    NSMutableArray * tupleString = [[NSMutableArray alloc] init];
    [tupleString addObject:@"("];
    for (NSUInteger columnIdx = 0; columnIdx < tupleSize; columnIdx++)
    {
        if (columnIdx > 0)
        {
            [tupleString addObject:@","];
        }
        [tupleString addObject:@"?"];
    }
    [tupleString addObject:@")"];
    
    return [tupleString componentsJoinedByString:@" "];
}



@end
