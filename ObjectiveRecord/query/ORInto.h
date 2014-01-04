//
//  ORInto.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2014/01/02.
//  Copyright (c) 2014年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORSqlable.h"

@interface ORInto : NSObject <ORSqlable>

- (id)initWithInsert:(id<ORSqlable>)insert table:(Class)table;

- (ORInto *)or_columns:(NSArray *)columns;

- (ORInto *)or_values:(NSArray *)values;


- (int64_t)or_execute;

@end

@interface ORInto (Interface)

#ifdef ObjectiveRecordBlockStyle

- (ORInto *(^)(NSArray *columns))columns;
- (ORInto *(^)(NSArray *values))values;
#else
#endif


@end
