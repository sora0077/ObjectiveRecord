//
//  ORSet.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORSet.h"
#import "ORUpdate.h"
#import "ORSQLiteUtils.h"

@implementation ORSet
{
    ORUpdate *_update;

    NSString *_set;
    NSString *_where;

    NSArray *_setArgs;
    NSArray *_whereArgs;
}

- (id)initWithUpdate:(ORUpdate *)update set:(NSString *)set
{
    return [self initWithUpdate:update set:set args:nil];
}

- (id)initWithUpdate:(ORUpdate *)update set:(NSString *)set args:(NSArray *)args
{
    self = [super init];
    if (self) {
        _update = update;
        _set = set;
        _setArgs = args;
    }
    return self;
}

- (ORSet *)or_where:(NSString *)where
{
    return [self or_where:where args:nil];
}

- (ORSet *)or_where:(NSString *)where args:(NSArray *)args
{
    _where = where;
    _whereArgs = args;

    return self;
}

- (NSArray *)getArguments
{
    NSMutableArray *args = [NSMutableArray array];
    if (_setArgs.count) {
        [args addObjectsFromArray:_setArgs];
    }
    if (_whereArgs.count) {
        [args addObjectsFromArray:_whereArgs];
    }
    return args;
}

- (void)or_execute
{
    [ORSQLiteUtils execQuery:[self toSql]
                        args:[self getArguments]];
}

- (NSString *)toSql
{
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:_update.toSql];
    [sql appendString:@"SET "];
    [sql appendString:_set];
    [sql appendString:@" "];

    if (_where) {
        [sql appendString:@"WHERE "];
        [sql appendString:_where];
        [sql appendString:@" "];
    }

    return sql;
}


@end
