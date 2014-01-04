//
//  ORSelect.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORSelect.h"
#import "ORFrom.h"


@implementation ORSelect
{
    NSArray *_columns;
    BOOL _distinct;
    BOOL _all;
}

- (id)initWithColumns:(NSArray *)columns
{
    self = [super init];
    if (self) {
        _columns = columns;
    }
    return self;
}

- (ORSelect *)or_distinct
{
    _distinct = YES;
    _all = NO;

    return self;
}

- (ORSelect *)or_all
{
    _distinct = NO;
    _all = YES;

    return self;
}

- (ORFrom *)or_from:(Class)table
{
    return [[ORFrom alloc] initWithTable:table query:self];
}

- (NSString *)toSql
{
    NSMutableString *sql = [NSMutableString string];

    [sql appendString:@"SELECT "];
    if (_distinct) {
        [sql appendString:@"DISTINCT "];
    } else if (_all) {
        [sql appendString:@"ALL "];
    }

    if (_columns.count) {
        [sql appendFormat:@"%@ ", [_columns componentsJoinedByString:@", "]];
    } else {
        [sql appendString:@"* "];
    }
    return sql;
}


@end

@implementation ORSelect (Interface)

#ifdef ObjectiveRecordBlockStyle

//ORSelect *Select()
//{
//    return [[ORSelect alloc] initWithColumns:nil];
//}

ORSelect *Select(NSArray *columns)
{
    return [[ORSelect alloc] initWithColumns:columns];
}

- (ORSelect *(^)())distinct
{
    return ^ORSelect *() {
        return [self or_distinct];
    };
}

- (ORSelect *(^)())all
{
    return ^ORSelect *() {
        return [self or_all];
    };
}

- (ORFrom *(^)(__unsafe_unretained Class))from
{
    return ^ORFrom *(__unsafe_unretained Class table) {
        return [self or_from:table];
    };
}

#else

#endif

@end

