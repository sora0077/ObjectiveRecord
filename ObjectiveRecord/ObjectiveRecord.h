//
//  ObjectiveRecord.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/08/19.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabasePool.h>
#import <FMDB/FMDatabaseQueue.h>




@interface ObjectiveRecord : NSObject

+ (void)syncDB:(NSString *)path table:(void (^)())block;

+ (FMDatabaseQueue *)defaultQueue;

+ (void)beginTransaction:(BOOL (^)())block;

@end
