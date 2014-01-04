//
//  ObjectiveRecord.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/08/19.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ObjectiveRecord.h"
#import "ObjectiveRecord+Private.h"


@interface ObjectiveRecord ()
@property (nonatomic, strong) FMDatabaseQueue *queue;
@property (nonatomic, strong) NSString *path;
@end

@implementation ObjectiveRecord
{
    FMDatabase *_g_DB;
}

+ (instancetype)sharedManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setG_DB:(FMDatabase *)g_DB
{
    _g_DB = g_DB;
}

- (FMDatabase *)g_DB
{
    return _g_DB;
}

+ (FMDatabaseQueue *)defaultQueue
{
    return [[self sharedManager] queue];
}


+ (void)beginTransaction:(BOOL (^)())block
{
    [[self defaultQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [[self sharedManager] setG_DB:db];
        *rollback = !block();
        [[self sharedManager] setG_DB:nil];
    }];
}

+ (void)syncDB:(NSString *)path table:(void (^)())block
{
    [[self sharedManager] setPath:path];
    FMDatabaseQueue *queue = [[self sharedManager] queue];

    NSLog(@"1");
    [queue inDatabase:^(FMDatabase *db) {
        [[self sharedManager] setG_DB:db];
        db.traceExecution = YES;

        NSLog(@"2");
        FMResultSet *result = [db executeQuery:@"SELECT * FROM Person"];

        while (result.next) {
            NSLog(@"%@", result.resultDictionary);
        }
        
        if (block) {
            block();
        }
    }];
    NSLog(@"3");
}

- (void)setPath:(NSString *)path
{
    _path = path;
    if (path) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
}

@end
