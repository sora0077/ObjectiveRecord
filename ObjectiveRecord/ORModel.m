//
//  ORModel.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORModel.h"
#import "ORCache.h"
#import "ORTableInfo.h"
#import "ORDelete.h"
#import "ORFrom.h"
#import "ORInsert.h"
#import "ORInto.h"
#import "ORUpdate.h"
#import "ORSet.h"
#import "ORSelect.h"
#import "ORProperty.h"

@interface ORModel ()
@property (strong, nonatomic) NSMutableDictionary *pool;
@end

@implementation ORModel
{
    ORTableInfo *_tableInfo;
}
@dynamic id;

+ (ORFrom *)objects
{
    return [[[ORSelect alloc] initWithColumns:nil] or_from:self];
}

+ (void)delete:(NSNumber *)id
{
    [[[[ORDelete new] or_from:self] or_where:@"id = ?" args:@[id]] or_execute];
}

- (id)init
{
    self = [super init];
    if (self) {
        _tableInfo = [ORCache tableInfo:[self class]];
        _pool = @{}.mutableCopy;
    }
    return self;
}

- (NSNumber *)id
{
    return self.pool[@"id"];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL ret = [super respondsToSelector:aSelector];
    if (ret == NO) {
        return [_tableInfo attributeForSelector:aSelector] != nil;
    }
    return ret;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        NSString *sel = NSStringFromSelector(aSelector);
        ORPropertyAttribute *attribute = [_tableInfo attributeForSelector:aSelector];
        if ([attribute.setter isEqualToString:sel]) {
            return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
        }
        if ([attribute.getter isEqualToString:sel]) {
            return [NSMethodSignature signatureWithObjCTypes:"@@:"];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSString *sel = NSStringFromSelector([anInvocation selector]);

    ORPropertyAttribute *attribute = [_tableInfo attributeForKey:sel];
    NSString *key = attribute.name;
    if ([attribute.setter isEqualToString:sel]) {
        __unsafe_unretained NSString *obj;
        [anInvocation getArgument:&obj atIndex:2];
        [self.pool setObject:obj forKey:key ?: [NSNull null]];
        return;
    }
    if ([attribute.getter isEqualToString:sel]) {
        NSString *obj = [self.pool objectForKey:key];
        [anInvocation setReturnValue:&obj];
        return;
    }
    [super forwardInvocation:anInvocation];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    ORPropertyAttribute *attribute = [_tableInfo attributeForKey:key];
    if (attribute) {
        [self.pool setValue:value forKey:key];
    } else {
        [super setValue:value forKey:key];
    }
}

- (id)valueForKey:(NSString *)key
{
    ORPropertyAttribute *attribute = [_tableInfo attributeForKey:key];
    if (attribute) {
        return [self.pool valueForKey:key];
    } else {
        return [super valueForKey:key];
    }
}

- (void)delete
{
    NSParameterAssert(self.id);
    [[self class] delete:self.id];
    [ORCache removeEntity:self];

    NSNotification *notification = [NSNotification notificationWithName:@""
                                                                 object:self
                                                               userInfo:@{}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)save
{
    NSMutableArray *columns = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];

    NSMutableDictionary *fields = [[self dictionaryWithValuesForKeys:[_tableInfo.fields valueForKeyPath:@"name"]] mutableCopy];
    [fields removeObjectForKey:@"id"];
    for (NSString *key in fields) {
        [columns addObject:key];
        [values addObject:fields[key]];
    }

    if (self.id) {
        // Update
        NSString *set = [columns componentsJoinedByString:@" = ?, "];
        set = [set stringByAppendingString:@" = ?"];
        [[[[[ORUpdate alloc] initWithTable:[self class]] or_set:set args:values] or_where:@"id = ?" args:@[self.id]] or_execute];
    } else {
        // Insert
        int64_t insertRowId = [[[[[ORInsert new] or_into:[self class]] or_columns:columns] or_values:values] or_execute];
        if (!(insertRowId > 0)) {
            @throw [NSException exceptionWithName:@"sss"
                                           reason:@""
                                         userInfo:nil];
        }
        [self setValue:@(insertRowId) forKey:@"id"];
        [ORCache addEntity:self];
    }
}

- (void)loadFromCursor:(NSDictionary *)dict
{
    [self setValuesForKeysWithDictionary:dict];
    [ORCache addEntity:self];
}

@end
