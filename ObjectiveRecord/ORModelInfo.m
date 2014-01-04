//
//  ORModelInfo.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORModelInfo.h"

@implementation ORModelInfo
{
    NSMutableDictionary *_tableInfos;
}

- (id)init
{
    self = [super init];
    if (self) {
        _tableInfos = @{}.mutableCopy;
    }
    return self;
}

- (ORTableInfo *)tableInfo:(Class)table
{
    NSString *tableClass = NSStringFromClass(table);
    ORTableInfo *info = _tableInfos[tableClass];
    if (info) {
        return info;
    }
    info = [[ORTableInfo alloc] initWithTable:table];
    _tableInfos[tableClass] = info;
    return info;
}

@end
