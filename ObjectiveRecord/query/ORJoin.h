//
//  ORJoin.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORSqlable.h"


typedef NS_ENUM(NSInteger, ORJoinType) {
    ORJoinTypeNone = 0,
    ORJoinTypeLEFT,
    ORJoinTypeOUTER,
    ORJoinTypeINNER,
    ORJoinTypeCROSS,
};

@class ORFrom;
@interface ORJoin : NSObject <ORSqlable>

- (id)initWithFrom:(ORFrom *)from table:(Class)table type:(ORJoinType)type;

- (ORJoin *)or_as:(NSString *)alias;

- (ORFrom *)or_on:(NSString *)on;
- (ORFrom *)or_on:(NSString *)on args:(NSArray *)args;

- (ORFrom *)or_using:(NSArray *)columns;



@end



@interface ORJoin (Interface)

#ifdef ObjectiveRecordBlockStyle
- (ORJoin *(^)(NSString *alias))as;
- (ORFrom *(^)(NSString *on, NSArray *args))on;
- (ORFrom *(^)(NSArray *columns))using;
#else

- (ORJoin *)as:(NSString *)alias;

- (ORFrom *)on:(NSString *)on;
- (ORFrom *)on:(NSString *)on args:(NSArray *)args;

- (ORFrom *)using:(NSArray *)columns;


#endif
@end
