//
//  ORUpdate.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORSqlable.h"

@class ORSet;
@interface ORUpdate : NSObject <ORSqlable>

- (id)initWithTable:(Class)table;

- (ORSet *)or_set:(NSString *)set;
- (ORSet *)or_set:(NSString *)set args:(NSArray *)args;


@end



@interface ORUpdate (Interface)

#ifdef ObjectiveRecordBlockStyle

extern ORUpdate *Update(Class table);

- (ORSet *(^)(NSString *set, NSArray *args))set;
#else

#endif

@end
