//
//  ORJoin.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORJoin.h"
#import "ORCache.h"
#import "ORFrom.h"
#import "ORFrom+Private.h"


@implementation ORJoin
{
    ORFrom *_from;
    Class _table;
    ORJoinType _type;

    NSString *_alias;
    NSString *_on;
    NSArray *_using;
}

- (id)initWithFrom:(ORFrom *)from table:(Class)table type:(ORJoinType)type
{
    self = [super init];
    if (self) {
        _from = from;
        _table = table;
        _type = type;
    }
    return self;
}

- (ORJoin *)or_as:(NSString *)alias
{
    _alias = alias;
    return self;
}

- (ORFrom *)or_on:(NSString *)on
{
    return [self or_on:on args:nil];
}

- (ORFrom *)or_on:(NSString *)on args:(NSArray *)args
{
    _on = on;
    [_from addArguments:args];
    return _from;
}

- (ORFrom *)or_using:(NSArray *)columns
{
    _using = columns;
    return _from;
}

- (NSString *)joinType:(ORJoinType)type
{
    switch (type) {
        case ORJoinTypeLEFT:
            return @"LEFT";
        case ORJoinTypeINNER:
            return @"INNER";
        case ORJoinTypeOUTER:
            return @"OUTER";
        case ORJoinTypeCROSS:
            return @"CROSS";
        default:
            return nil;
    }
}

- (NSString *)toSql
{
    NSMutableString *sql = [NSMutableString string];
    if (_type != ORJoinTypeNone) {
        [sql appendString:[self joinType:_type]];
        [sql appendString:@" "];
    }

    [sql appendString:@"JOIN "];
    [sql appendString:[ORCache tableName:_table]];
    [sql appendString:@" "];

    if (_alias) {
        [sql appendString:@"AS "];
        [sql appendString:_alias];
        [sql appendString:@" "];
    }

    if (_on) {
        [sql appendString:@"ON "];
        [sql appendString:_on];
        [sql appendString:@" "];
    } else if (_using) {
        [sql appendString:@"USING ("];
        [sql appendString:[_using componentsJoinedByString:@", "]];
        [sql appendString:@") "];
    }

    return sql;
}

@end


@implementation ORJoin (Interface)

#ifdef ObjectiveRecordBlockStyle

- (ORJoin *(^)(NSString *))as
{
    return ^ORJoin *(NSString *as) {
        return [self or_as:as];
    };
}

- (ORFrom *(^)(NSString *, NSArray *))on
{
    return ^ORFrom *(NSString *on, NSArray *args) {
        return [self or_on:on args:args];
    };
}

- (ORFrom *(^)(NSArray *))using
{
    return ^ORFrom *(NSArray *columns) {
        return [self or_using:columns];
    };
}

#else
#endif

@end

