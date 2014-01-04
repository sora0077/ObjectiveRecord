//
//  ObjectiveRecord+Private.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2014/01/02.
//  Copyright (c) 2014年 林 達也. All rights reserved.
//

#import "ObjectiveRecord.h"

@interface ObjectiveRecord (Private)

+ (instancetype)sharedManager;
@property (nonatomic, strong) FMDatabase *g_DB;
@end
