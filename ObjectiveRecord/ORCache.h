//
//  ORCache.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORModel;
@class ORTableInfo;
@interface ORCache : NSObject


+ (void)addEntity:(ORModel *)entity;
+ (ORModel *)getEntity:(Class)table id:(NSNumber *)id;
+ (void)removeEntity:(ORModel *)entity;


+ (ORTableInfo *)tableInfo:(Class)table;

+ (NSString *)tableName:(Class)table;

@end
