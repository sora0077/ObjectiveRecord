//
//  ORInto.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2014/01/02.
//  Copyright (c) 2014年 林 達也. All rights reserved.
//

#import "ORInto.h"
#import "ORCache.h"
#import "ORSQLiteUtils.h"

@implementation ORInto
{
    NSArray *_columns;
    NSArray *_values;
    Class _table;
    id<ORSqlable> _insert;
}

- (id)initWithInsert:(id<ORSqlable>)insert table:(Class)table
{
    self = [super init];
    if (self) {
        _insert = insert;
        _table = table;
    }
    return self;
}

- (ORInto *)or_columns:(NSArray *)columns
{
    _columns = columns;
    return self;
}

- (ORInto *)or_values:(NSArray *)values
{
    _values = values;
    return self;
}

- (int64_t)or_execute
{
    __block int64_t insertRowId = -1;
    [ORSQLiteUtils execQuery:[self toSql]
                        args:_values
                     process:^(int64_t lastInsertRowId) {
                         insertRowId = lastInsertRowId;
                     }];
    return insertRowId;
}

- (NSString *)toSql
{
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:[_insert toSql]];
    [sql appendString:@"INTO "];
    [sql appendString:[ORCache tableName:_table]];

    if (_columns.count) {
        [sql appendString:@"("];
        [sql appendString:[_columns componentsJoinedByString:@", "]];
        [sql appendString:@") "];
    }

    [sql appendString:@"VALUES ("];
    for (id obj in _values) {
        if (obj == _values.lastObject) {
            [sql appendString:@"?"];
        } else {
            [sql appendString:@"?, "];
        }
    }
    [sql appendString:@")"];

    return sql;
}

@end

@implementation ORInto (Interface)

#ifdef ObjectiveRecordBlockStyle

- (ORInto *(^)(NSArray *))columns
{
    return ^ORInto *(NSArray *columns) {
        return [self or_columns:columns];
    };
}


- (ORInto *(^)(NSArray *))values
{
    return ^ORInto *(NSArray *values) {
        return [self or_values:values];
    };
}

#else
#endif

@end
