//
//  FMDatabaseQueue+ObjectiveRecord.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/08/20.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "FMDatabaseQueue+ObjectiveRecord.h"

@implementation FMDatabaseQueue (ObjectiveRecord)

+ (instancetype)defaultQueue
{
    static FMDatabaseQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[FMDatabaseQueue alloc] initWithPath:nil];
    });
    return queue;
}

@end
