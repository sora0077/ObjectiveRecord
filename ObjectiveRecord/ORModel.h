//
//  ORModel.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORFrom.h"

@interface ORModel : NSObject
@property (readonly) NSNumber *id;

+ (ORFrom *)objects;
+ (void)delete:(NSNumber *)id;

- (void)delete;
- (void)save;


- (void)loadFromCursor:(NSDictionary *)dict;

//- (NSArray *)getManyTable:(Class)table foreignKey:(NSString *)key;

@end
