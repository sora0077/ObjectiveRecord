//
//  ORAppDelegate.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2013/08/15.
//  Copyright (c) 2013年 林 達也. All rights reserved.
//

#import "ORAppDelegate.h"

#import "ObjectiveRecord.h"

#import "ORSelect.h"
#import "ORFrom.h"
#import "ORJoin.h"


#import "Person.h"
#import "Book.h"

@implementation ORAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"test.db"];
    NSString *path = dbPath;

    [ObjectiveRecord syncDB:path table:^{
    }];

    NSLog(@"%@", [@[@1, @2.4343434343434344545645667567] componentsJoinedByString:@", "]);


    NSLog(@"%@", Select(nil).from([Person class]).leftJoin([Book class]).on(@"Person.bookId = Book.id", nil).where(@"personId = ?", @[@2]).toSql);
    ;

    NSLog(@"%@", ({
        ORFrom *from = [[ORFrom alloc] initWithTable:[Person class] query:nil];
        from.limit(10).toSql;
    }));

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
