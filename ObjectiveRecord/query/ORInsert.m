//
//  ORInsert.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2014/01/02.
//  Copyright (c) 2014年 林 達也. All rights reserved.
//

#import "ORInsert.h"
#import "ORInto.h"

@implementation ORInsert

- (ORInto *)or_into:(Class)table
{
    return [[ORInto alloc] initWithInsert:self table:table];
}


- (NSString *)toSql
{
    return @"INSERT ";
}

@end


@implementation ORInsert (Interface)
#ifdef ObjectiveRecordBlockStyle

ORInsert *Insert()
{
    return [[ORInsert alloc] init];
}

- (ORInto *(^)(__unsafe_unretained Class))into
{
    return ^ORInto *(Class table) {
        return [self or_into:table];
    };
}

#else
#endif

@end
