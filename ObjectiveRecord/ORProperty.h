//
//  ORProperty.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/08/17.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORProperty : NSObject
@property (readonly) Class clazz;
@property (readonly) NSArray *properties;

- (id)initWithClass:(Class)clazz;
- (id)initWithClass:(Class)clazz recursive:(BOOL)recursive dynamic:(BOOL)dynamic;
@end


@interface ORPropertyAttribute : NSObject

@property (readonly) BOOL primitive;
@property (readonly) BOOL dynamic;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *setter;
@property (nonatomic, copy) NSString *getter;

@end