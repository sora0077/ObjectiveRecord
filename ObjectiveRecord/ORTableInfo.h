//
//  ORTableInfo.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORPropertyAttribute;
@interface ORTableInfo : NSObject

- (id)initWithTable:(Class)table;

- (NSString *)tableName;

- (NSArray *)fields;


- (ORPropertyAttribute *)attributeForSelector:(SEL)aSelector;
- (ORPropertyAttribute *)attributeForKey:(NSString *)aKey;

@end
