//
//  ORSqlable.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/12/31.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ORSqlable <NSObject>

- (NSString *)toSql;

@end
