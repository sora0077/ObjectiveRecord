//
//  ORDelete.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORSqlable.h"

@class ORFrom;
@interface ORDelete : NSObject <ORSqlable>

- (ORFrom *)or_from:(Class)table;

@end

@interface ORDelete (Interface)

#ifdef ObjectiveRecordBlockStyle

extern ORDelete *Delete();

- (ORFrom *(^)(Class table))from;
#else
#endif
@end