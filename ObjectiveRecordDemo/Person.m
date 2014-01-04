//
//  Person.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "Person.h"

@implementation Person

@dynamic name;
//@dynamic books;

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@", [super description], self.id, self.name];
}

@end
