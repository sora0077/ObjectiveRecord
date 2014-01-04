//
//  ORCache.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORCache.h"
#import "ORModelInfo.h"
#import "ORModel.h"

@implementation ORCache
{
    ORModelInfo *_modelInfo;
    NSCache *_entities;
}

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _modelInfo = [[ORModelInfo alloc] init];
        _entities = [[NSCache alloc] init];
    }
    return self;
}

+ (void)addEntity:(ORModel *)entity
{
    ORCache *cache = [self sharedInstance];
    [cache->_entities setObject:entity forKey:[self getIdentifier:entity]];
}

+ (ORModel *)getEntity:(Class)table id:(NSNumber *)id
{
    ORCache *cache = [self sharedInstance];
    return [cache->_entities objectForKey:[self getIdentifier:table id:id]];
}

+ (void)removeEntity:(ORModel *)entity
{
    ORCache *cache = [self sharedInstance];
    [cache->_entities removeObjectForKey:[self getIdentifier:entity]];
}


+ (ORTableInfo *)tableInfo:(Class)table
{
    ORCache *cache = [self sharedInstance];
    return [cache->_modelInfo tableInfo:table];
}

+ (NSString *)tableName:(Class)table
{
    return [[self tableInfo:table] tableName];
}


+ (NSString *)getIdentifier:(ORModel *)entity
{
    return [self getIdentifier:[entity class] id:entity.id];
}

+ (NSString *)getIdentifier:(Class)table id:(NSNumber *)id
{
    return [NSString stringWithFormat:@"%@@%@", id, [self tableName:table]];
}

@end
