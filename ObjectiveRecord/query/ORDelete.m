//
//  ORDelete.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORDelete.h"
#import "ORFrom.h"

@implementation ORDelete

- (ORFrom *)or_from:(Class)table
{
    return [[ORFrom alloc] initWithTable:table query:self];
}

- (NSString *)toSql
{
    return @"DELETE ";
}

@end


@implementation ORDelete (Interface)


#ifdef ObjectiveRecordBlockStyle

ORDelete *Delete()
{
    return [[ORDelete alloc] init];
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
