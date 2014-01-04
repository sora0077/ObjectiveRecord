//
//  ORTableInfo.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORTableInfo.h"
#import "ORProperty.h"

@implementation ORTableInfo
{
    Class _table;
    NSArray *_fields;
    NSString *_tableName;
    ORProperty *_property;
    NSDictionary *_attributeForSels;
}

- (id)initWithTable:(Class)table
{
    self = [super init];
    if (self) {
        _table = table;
    }
    return self;
}

- (ORProperty *)property
{
    if (_property == nil) {
        _property = [[ORProperty alloc] initWithClass:_table];
    }
    return _property;
}

- (NSDictionary *)attributeForSels
{
    if (_attributeForSels == nil) {
        NSMutableDictionary *dict = @{}.mutableCopy;
        for (ORPropertyAttribute *attr in [self property].properties) {
            dict[attr.setter] = attr;
            dict[attr.getter] = attr;
            dict[attr.name]   = attr;
        }
        _attributeForSels = dict;
    }
    return _attributeForSels;
}

- (NSArray *)fields
{
    if (_fields == nil) {
        NSMutableArray *fields = [NSMutableArray array];
        ORProperty *property = [self property];
        for (ORPropertyAttribute *attribute in property.properties) {
            if (attribute.dynamic) {
                [fields addObject:attribute];
            }
        }
        _fields = fields;
    }
    return _fields;
}

- (NSString *)tableName
{
    if (_tableName == nil) {
        _tableName = NSStringFromClass(_table);
    }
    return _tableName;
}

- (ORPropertyAttribute *)attributeForSelector:(SEL)aSelector
{
    NSString *sel = NSStringFromSelector(aSelector);
    return [self attributeForSels][sel];
}

- (ORPropertyAttribute *)attributeForKey:(NSString *)aKey
{
    return [self attributeForSels][aKey];
}

@end
