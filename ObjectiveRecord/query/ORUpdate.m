//
//  ORUpdate.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORUpdate.h"
#import "ORCache.h"
#import "ORSet.h"

@implementation ORUpdate
{
    Class _table;
}

- (id)initWithTable:(Class)table
{
    self = [super init];
    if (self) {
        _table = table;
    }
    return self;
}

- (ORSet *)or_set:(NSString *)set
{
    return [self or_set:set args:nil];
}

- (ORSet *)or_set:(NSString *)set args:(NSArray *)args
{
    return [[ORSet alloc] initWithUpdate:self set:set args:args];
}

- (NSString *)toSql
{
    NSMutableString *sql = [NSMutableString string];

    [sql appendString:@"UPDATE "];
    [sql appendString:[ORCache tableName:_table]];
    [sql appendString:@" "];
    return sql;
}

@end



@implementation ORUpdate (Interface)

#ifdef ObjectiveRecordBlockStyle

ORUpdate *Update(Class table)
{
    return [[ORUpdate alloc] initWithTable:table];
}

- (ORSet *(^)(NSString *, NSArray *))set
{
    return ^ORSet *(NSString *set, NSArray *args) {
        return [self or_set:set args:args];
    };
}
#else
#endif

@end


