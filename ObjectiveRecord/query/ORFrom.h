//
//  ORFrom.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORSqlable.h"

@class ORModel;
@class ORJoin;
@interface ORFrom : NSObject<ORSqlable>

- (id)initWithTable:(Class)table query:(id<ORSqlable>)queryBase;

- (ORFrom *)or_as:(NSString *)alias;


- (ORJoin *)or_join:(Class)table;
- (ORJoin *)or_leftJoin:(Class)table;
- (ORJoin *)or_outerJoin:(Class)table;
- (ORJoin *)or_innerJoin:(Class)table;
- (ORJoin *)or_crossJoin:(Class)table;


- (ORFrom *)or_where:(NSString *)where;
- (ORFrom *)or_where:(NSString *)where args:(NSArray *)args;

- (ORFrom *)or_groupBy:(NSString *)groupBy;
- (ORFrom *)or_having:(NSString *)having;
- (ORFrom *)or_orderBy:(NSString *)orderBy;

- (ORFrom *)or_limit:(NSUInteger)limit;
- (ORFrom *)or_offset:(NSUInteger)offset;


- (NSArray *)or_execute;
- (ORModel *)or_executeOne;
@end


@interface ORFrom (Interface)

#ifdef ObjectiveRecordBlockStyle

- (ORFrom *(^)(NSString *alias))as;

- (ORJoin *(^)(Class table))join;
- (ORJoin *(^)(Class table))leftJoin;
- (ORJoin *(^)(Class table))outerJoin;
- (ORJoin *(^)(Class table))innerJoin;
- (ORJoin *(^)(Class table))crossJoin;

- (ORFrom *(^)(NSString *where, NSArray *args))where;

- (ORFrom *(^)(NSString *groupBy))groupBy;
- (ORFrom *(^)(NSString *having))having;
- (ORFrom *(^)(NSString *orderBy))orderBy;

- (ORFrom *(^)(NSUInteger limit))limit;
- (ORFrom *(^)(NSUInteger offset))offset;

- (NSArray *(^)())execute;
- (ORModel *(^)())executeOne;

#else

- (ORFrom *)as:(NSString *)alias;


- (ORJoin *)join:(Class)table;
- (ORJoin *)leftJoin:(Class)table;
- (ORJoin *)outerJoin:(Class)table;
- (ORJoin *)innerJoin:(Class)table;
- (ORJoin *)crossJoin:(Class)table;

- (ORFrom *)where:(NSString *)where;
- (ORFrom *)where:(NSString *)where args:(NSArray *)args;

- (ORFrom *)groupBy:(NSString *)groupBy;
- (ORFrom *)having:(NSString *)having;
- (ORFrom *)orderBy:(NSString *)orderBy;

- (ORFrom *)limit:(NSUInteger)limit;
- (ORFrom *)offset:(NSUInteger)offset;


- (NSArray *)execute;
- (ORModel *)executeOne;

#endif

@end

