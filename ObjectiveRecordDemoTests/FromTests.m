//
//  FromTest.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2014/01/01.
//  Copyright (c) 2014年 林 達也. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "ORFrom.h"
#import "Person.h"

SPEC_BEGIN(FromTests)

describe(@"FROM ", ^{
    it(@"limit", ^{
        ORFrom *from = [[ORFrom alloc] initWithTable:[Person class] query:nil];
        [[from.limit(10).toSql should] equal:@"FROM Person LIMIT 1a0"];
    });
});

SPEC_END
