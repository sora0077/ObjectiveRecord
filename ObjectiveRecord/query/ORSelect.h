//
//  ORSelect.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORSqlable.h"
#import "ORFrom.h"

@class ORModel;
@class ORFrom;
@interface ORSelect : NSObject <ORSqlable>

- (id)initWithColumns:(NSArray *)columns;


- (ORSelect *)or_distinct;
- (ORSelect *)or_all;

- (ORFrom *)or_from:(Class)table;

//+ 

@end


@interface ORSelect (Interface)
#ifdef ObjectiveRecordBlockStyle
extern ORSelect * Select(NSArray *columns);

- (ORSelect *(^)())distinct;
- (ORSelect *(^)())all;

- (ORFrom *(^)(Class table))from;

#else
- (ORSelect *)distinct;
- (ORSelect *)all;

- (ORFrom *)from:(Class)table;
#endif
@end
