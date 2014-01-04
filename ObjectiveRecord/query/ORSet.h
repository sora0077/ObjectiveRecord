//
//  ORSet.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORSqlable.h"

@class ORUpdate;
@interface ORSet : NSObject <ORSqlable>

- (id)initWithUpdate:(ORUpdate *)update set:(NSString *)set;
- (id)initWithUpdate:(ORUpdate *)update set:(NSString *)set args:(NSArray *)args;

- (ORSet *)or_where:(NSString *)where;
- (ORSet *)or_where:(NSString *)where args:(NSArray *)args;


- (void)or_execute;

@end
