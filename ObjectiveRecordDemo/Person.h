//
//  Person.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORModel.h"

@protocol Book;
@interface Person : ORModel
@property (strong, nonatomic) NSString *name;
//@property (strong, nonatomic) NSArray<Book> *books;
@end
