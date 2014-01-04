//
//  ORSQLiteUtils.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2014/01/01.
//  Copyright (c) 2014年 林 達也. All rights reserved.
//

#import "ORSQLiteUtils.h"
#import "ObjectiveRecord.h"
#import "ObjectiveRecord+Private.h"
#import "ORCache.h"
#import "ORModel.h"

@implementation ORSQLiteUtils

+ (void)execQuery:(NSString *)sql args:(NSArray *)args
{
    [self execQuery:sql args:args process:nil];
}

+ (void)execQuery:(NSString *)sql args:(NSArray *)args process:(void (^)(int64_t))process
{
    void (^block)(FMDatabase *) = ^(FMDatabase *db) {
        [db executeUpdate:sql withArgumentsInArray:args];
        if (process) {
            process(db.lastInsertRowId);
        }
    };
    FMDatabase *db = [ObjectiveRecord sharedManager].g_DB;
    if (db) {
        block(db);
    } else {
        [[ObjectiveRecord defaultQueue] inDatabase:^(FMDatabase *db) {
            block(db);
        }];
    }
}

+ (NSArray *)rawQuery:(NSString *)sql args:(NSArray *)args table:(__unsafe_unretained Class)table
{
    __block NSArray *entities;
    void (^block)(FMDatabase *db) = ^(FMDatabase *db) {
        FMResultSet *cursor = [db executeQuery:sql withArgumentsInArray:args];
        entities = [self processCursor:cursor table:table];
    };
    FMDatabase *db = [ObjectiveRecord sharedManager].g_DB;
    if (db) {
        block(db);
    } else {
        [[ObjectiveRecord defaultQueue] inDatabase:^(FMDatabase *db) {
            block(db);
        }];
    }
    return entities;
}

+ (ORModel *)rawQueryOne:(NSString *)sql args:(NSArray *)args table:(Class)table
{
    NSArray *entities = [self rawQuery:sql args:args table:table];
    if (entities.count > 0) {
        return entities[0];
    }
    return nil;
}


+ (NSArray *)processCursor:(FMResultSet *)cursor table:(Class)table
{
    NSMutableArray *entities = [NSMutableArray array];
    while (cursor.next) {
        NSDictionary *result = cursor.resultDictionary;
        ORModel *entity = [ORCache getEntity:table id:result[@"id"]];
        if (entity == nil) {
            entity = [[table alloc] init];
        }
        [entity loadFromCursor:result];
        [entities addObject:entity];
    }
    return entities;
}

@end
