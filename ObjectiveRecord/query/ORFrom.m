//
//  ORFrom.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORFrom.h"
#import "ORFrom+Private.h"
#import "ObjectiveRecord.h"
#import "ORCache.h"
#import "ORSQLiteUtils.h"
#import "ORSelect.h"
#import "ORJoin.h"

@implementation ORFrom
{
    Class _table;
    id<ORSqlable> _queryBase;
    NSString *_alias;
    NSMutableArray *_joins;

    NSString *_where;
    NSString *_groupBy;
    NSString *_having;
    NSString *_orderBy;
    NSUInteger _limit;
    NSUInteger _offset;

    NSMutableArray *_args;
}

- (id)initWithTable:(Class)table query:(id<ORSqlable>)queryBase
{
    self = [super init];
    if (self) {
        _table = table;
        _queryBase = queryBase;
    }
    return self;
}

- (NSMutableArray *)_joins
{
    if (_joins == nil) {
        _joins = @[].mutableCopy;
    }
    return _joins;
}

- (ORFrom *)or_as:(NSString *)alias
{
    _alias = alias;
    return self;
}

- (ORJoin *)or_join:(Class)table
{
    ORJoin *join = [[ORJoin alloc] initWithFrom:self table:table type:ORJoinTypeNone];
    [self._joins addObject:join];
    return join;
}

- (ORJoin *)or_leftJoin:(Class)table
{
    ORJoin *join = [[ORJoin alloc] initWithFrom:self table:table type:ORJoinTypeLEFT];
    [self._joins addObject:join];
    return join;
}

- (ORJoin *)or_outerJoin:(Class)table
{
    ORJoin *join = [[ORJoin alloc] initWithFrom:self table:table type:ORJoinTypeOUTER];
    [self._joins addObject:join];
    return join;
}

- (ORJoin *)or_innerJoin:(Class)table
{
    ORJoin *join = [[ORJoin alloc] initWithFrom:self table:table type:ORJoinTypeINNER];
    [self._joins addObject:join];
    return join;
}

- (ORJoin *)or_crossJoin:(Class)table
{
    ORJoin *join = [[ORJoin alloc] initWithFrom:self table:table type:ORJoinTypeCROSS];
    [self._joins addObject:join];
    return join;
}

- (ORFrom *)or_where:(NSString *)where
{
    return [self or_where:where args:nil];
}

- (ORFrom *)or_where:(NSString *)where args:(NSArray *)args
{
    _where = where;
    _args = args.mutableCopy;
    return self;
}

- (ORFrom *)or_groupBy:(NSString *)groupBy
{
    _groupBy = groupBy;
    return self;
}

- (ORFrom *)or_having:(NSString *)having
{
    _having = having;
    return self;
}

- (ORFrom *)or_orderBy:(NSString *)orderBy
{
    _orderBy = orderBy;
    return self;
}

- (ORFrom *)or_limit:(NSUInteger)limit
{
    _limit = limit;
    return self;
}

- (ORFrom *)or_offset:(NSUInteger)offset
{
    _offset = offset;
    return self;
}

- (void)addArguments:(NSArray *)args
{
    if (_args == nil) {
        _args = [NSMutableArray array];
    }
    [_args addObjectsFromArray:args];
}

- (NSString *)toSql
{
    NSMutableString *sql = [NSMutableString string];
    if (_queryBase) {
        [sql appendString:[_queryBase toSql]];
    }
    [sql appendString:@"FROM "];
    [sql appendString:[ORCache tableName:_table]];
    [sql appendString:@" "];

    if (_alias) {
        [sql appendString:@"AS "];
        [sql appendString:_alias];
        [sql appendString:@" "];
    }

    for (ORJoin *join in _joins) {
        [sql appendString:join.toSql];
    }

    if (_where) {
        [sql appendString:@"WHERE "];
        [sql appendString:_where];
        [sql appendString:@" "];
    }

    if (_groupBy) {
        [sql appendString:@"GROUP BY "];
        [sql appendString:_groupBy];
        [sql appendString:@" "];
    }

    if (_having) {
        [sql appendString:@"HAVING "];
        [sql appendString:_having];
        [sql appendString:@" "];
    }

    if (_orderBy) {
        [sql appendString:@"ORDER BY "];
        [sql appendString:_orderBy];
        [sql appendString:@" "];
    }

    if (_limit) {
        [sql appendFormat:@"LIMIT %@ ", @(_limit)];
    }

    if (_offset) {
        [sql appendFormat:@"OFFSET %@ ", @(_offset)];
    }

    return sql;
}

- (NSArray *)getArguments
{
    return _args;
}

- (NSArray *)or_execute
{
    if ([_queryBase isKindOfClass:[ORSelect class]]) {
        return [ORSQLiteUtils rawQuery:[self toSql] args:[self getArguments] table:_table];
    } else {
        [ORSQLiteUtils execQuery:[self toSql] args:[self getArguments]];
        return nil;
    }
}

- (ORModel *)or_executeOne
{
    if ([_queryBase isKindOfClass:[ORSelect class]]) {
        [self or_limit:1];
        return [ORSQLiteUtils rawQueryOne:[self toSql] args:[self getArguments] table:_table];
    } else {
        [ORSQLiteUtils execQuery:[self toSql] args:[self getArguments]];
        return nil;
    }
}

@end



@implementation ORFrom (Interface)

#ifdef ObjectiveRecordBlockStyle

- (ORFrom *(^)(NSString *))as
{
    return ^ORFrom *(NSString *as) {
        return [self or_as:as];
    };
}

- (ORJoin *(^)(__unsafe_unretained Class))join
{
    return ^ORJoin *(__unsafe_unretained Class table) {
        return [self or_join:table];
    };
}

- (ORJoin *(^)(__unsafe_unretained Class))leftJoin
{
    return ^ORJoin *(__unsafe_unretained Class table) {
        return [self or_leftJoin:table];
    };
}

- (ORJoin *(^)(__unsafe_unretained Class))outerJoin
{
    return ^ORJoin *(__unsafe_unretained Class table) {
        return [self or_outerJoin:table];
    };
}

- (ORJoin *(^)(__unsafe_unretained Class))innerJoin
{
    return ^ORJoin *(__unsafe_unretained Class table) {
        return [self or_innerJoin:table];
    };
}

- (ORJoin *(^)(__unsafe_unretained Class))crossJoin
{
    return ^ORJoin *(__unsafe_unretained Class table) {
        return [self or_crossJoin:table];
    };
}

- (ORFrom *(^)(NSString *, NSArray *))where
{
    return ^ORFrom *(NSString *where, NSArray *args) {
        return [self or_where:where args:args];
    };
}

- (ORFrom *(^)(NSString *))groupBy
{
    return ^ORFrom *(NSString *groupBy) {
        return [self or_groupBy:groupBy];
    };
}

- (ORFrom *(^)(NSString *))having
{
    return ^ORFrom *(NSString *having) {
        return [self or_having:having];
    };
}

- (ORFrom *(^)(NSString *))orderBy
{
    return ^ORFrom *(NSString *orderBy) {
        return [self or_orderBy:orderBy];
    };
}

- (ORFrom *(^)(NSUInteger))limit
{
    return ^ORFrom *(NSUInteger limit) {
        return [self or_limit:limit];
    };
}

- (ORFrom *(^)(NSUInteger))offset
{
    return ^ORFrom *(NSUInteger offset) {
        return [self or_offset:offset];
    };
}

- (NSArray *(^)())execute
{
    return ^NSArray *() {
        return [self or_execute];
    };
}

- (ORModel *(^)())executeOne
{
    return ^ORModel *() {
        return [self or_executeOne];
    };
}

#else

- (ORFrom *)as:(NSString *)alias
{
    return [self or_as:alias];
}

- (ORJoin *)join:(Class)table
{
    return [self or_join:table];
}

- (ORJoin *)leftJoin:(Class)table
{
    return [self or_leftJoin:table];
}

- (ORJoin *)outerJoin:(Class)table
{
    return [self or_outerJoin:table];
}

- (ORJoin *)innerJoin:(Class)table
{
    return [self or_innerJoin:table];
}

- (ORJoin *)crossJoin:(Class)table
{
    return [self or_crossJoin:table];
}

- (ORFrom *)where:(NSString *)where
{
    return [self or_where:where];
}

- (ORFrom *)where:(NSString *)where args:(NSArray *)args
{
    return [self or_where:where args:args];
}

- (ORFrom *)groupBy:(NSString *)groupBy
{
    return [self or_groupBy:groupBy];
}

- (ORFrom *)having:(NSString *)having
{
    return [self or_having:having];
}

- (ORFrom *)orderBy:(NSString *)orderBy
{
    return [self or_orderBy:orderBy];
}

- (ORFrom *)limit:(NSUInteger)limit
{
    return [self or_limit:limit];
}

- (ORFrom *)offset:(NSUInteger)offset
{
    return [self or_offset:offset];
}

- (NSArray *)execute
{
    return [self or_execute];
}

- (ORModel *)executeOne
{
    return [self or_executeOne];
}

#endif

@end


