//
//  ORInsert.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2014/01/02.
//  Copyright (c) 2014年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORSqlable.h"

@class ORInto;
@interface ORInsert : NSObject <ORSqlable>


- (ORInto *)or_into:(Class)table;

@end

@interface ORInsert (Interface)

#ifdef ObjectiveRecordBlockStyle

extern ORInsert *Insert();

- (ORInto *(^)(Class table))into;
#else
#endif

@end
