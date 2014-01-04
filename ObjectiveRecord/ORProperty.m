//
//  ORProperty.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/08/17.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORProperty.h"
#import <objc/runtime.h>

@interface ORPropertyAttribute ()
- (id)initWithProperty:(objc_property_t)property;
@end



@implementation ORPropertyAttribute
{
    BOOL _primitive, _dynamic;
}

- (id)initWithProperty:(objc_property_t)property
{
    self = [super init];
    if (self) {
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];

        const char *propType = property_getAttributes(property);
        NSArray *propertyAttributesArray = [[NSString stringWithUTF8String:propType] componentsSeparatedByString:@","];

        NSDictionary *attributes = [ORPropertyAttribute attributesFromArray:propertyAttributesArray];

        NSString *type = attributes[@"T"];

        _name = propertyName;

        _dynamic = [propertyAttributesArray containsObject:@"D"];
        _primitive = ![type hasPrefix:@"@"];
        if (!_primitive && type.length > 2) {
            _type = [type substringWithRange:NSMakeRange(2, type.length - 3)];
        } else {
            _type = type;
        }

        NSString *setter = attributes[@"S"];
        if (setter) {
            _setter = setter;
        } else {
            NSString *prefix = [[propertyName substringToIndex:1] uppercaseString];
            NSString *suffix = [propertyName substringWithRange:NSMakeRange(1, propertyName.length - 1)];
            _setter = [NSString stringWithFormat:@"set%@%@:", prefix, suffix];
        }

        NSString *getter = attributes[@"G"];
        if (getter) {
            _getter = getter;
        } else {
            _getter = propertyName;
        }
//        NSLog(@"%@", attributes);
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ T:%@ name:%@ setter:%@ getter:%@>", self.class, _type, _name, _setter, _getter];
}

+ (NSDictionary *)attributesFromArray:(NSArray *)array
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    for (NSString *attibute in array) {
        NSString *key = [attibute substringToIndex:1];
        NSString *value = @"";
        if (attibute.length > 1) {
            value = [attibute substringWithRange:NSMakeRange(1, attibute.length - 1)];
        }
        [attributes setObject:value forKey:key];
    }
    return attributes;
}

@end



@implementation ORProperty
{
    Class _clazz;
    NSArray *_properties;
}

- (id)initWithClass:(Class)clazz
{
    return [self initWithClass:clazz recursive:YES dynamic:YES];
}


- (id)initWithClass:(Class)clazz recursive:(BOOL)recursive dynamic:(BOOL)dynamic
{
    self = [super init];
    if (self) {
        _clazz = clazz;
        NSMutableArray *properties = [NSMutableArray array];
        do {
            unsigned int outCount, i;
            objc_property_t *obj_properties = class_copyPropertyList(clazz, &outCount);
            for (i = 0; i < outCount; i++) {
                objc_property_t property = obj_properties[i];

                ORPropertyAttribute *attribute = [[ORPropertyAttribute alloc] initWithProperty:property];

                if (dynamic) {
                    if (attribute.dynamic) {
                        [properties addObject:attribute];
                    }
                } else{
                    [properties addObject:attribute];
                }
            }
            free(obj_properties);
            clazz = class_getSuperclass(clazz);
        } while (clazz != [NSObject class] && recursive);
        _properties = properties;
    }
    return self;
}

@end
