//
//  ObjectiveRecordDemoTests.m
//  ObjectiveRecordDemoTests
//
//  Created by 林 達也 on 2013/08/15.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "Person.h"

#import "ORSelect.h"
#import "ORFrom.h"


//SPEC_BEGIN(SELECT)
//
//describe(@"Model", ^{
//    context(@"when create entity", ^{
//        it(@"before create model", ^{
//            ORSelect *select = [[ORSelect alloc] initWithColumns:nil];
//            select.from([Person class]).where(nil, nil);
//        });
//    });
//});
//
//SPEC_END