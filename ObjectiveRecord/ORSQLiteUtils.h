//
//  ORSQLiteUtils.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2014/01/01.
//  Copyright (c) 2014年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORModel;
@interface ORSQLiteUtils : NSObject

+ (void)execQuery:(NSString *)sql args:(NSArray *)args;
+ (void)execQuery:(NSString *)sql args:(NSArray *)args process:(void (^)(int64_t lastInsertRowId))process;

+ (NSArray *)rawQuery:(NSString *)sql args:(NSArray *)args table:(Class)table;
+ (ORModel *)rawQueryOne:(NSString *)sql args:(NSArray *)args table:(Class)table;

@end
