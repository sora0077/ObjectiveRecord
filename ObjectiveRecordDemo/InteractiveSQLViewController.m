//
//  InteractiveSQLViewController.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2014/01/02.
//  Copyright (c) 2014年 林 達也. All rights reserved.
//

#import "InteractiveSQLViewController.h"
#import <DAKeyboardControl/DAKeyboardControl.h>
#import "TextInputToolbar.h"
#import "ORSQLiteUtils.h"
#import "ObjectiveRecord.h"
#import "HeaderView.h"
#import "Person.h"
#import "ORSelect.h"
#import "ORJoin.h"
#import "ObjectiveRecord.h"

@interface SQLResult : NSObject
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSMutableArray *results;
@property (nonatomic) BOOL result;
@end


@implementation SQLResult

+ (instancetype)empty
{
    SQLResult *result = [[self alloc] init];
    result.results = @[].mutableCopy;
    return result;
}

@end

@interface SQLResultCellContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation SQLResultCellContentCell



@end


@interface SQLResultCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
+ (CGFloat)height:(SQLResult *)result;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) SQLResult *result;
@end

@implementation SQLResultCell

+ (CGFloat)height:(SQLResult *)result
{
    CGFloat height = 20;
    if (result.results.count) {
        for (NSDictionary *dict in result.results) {
            height += 21 * dict.count;
            height += 1;
        }
    } else {
        height = 40;
    }
    return height;
}

- (void)setResult:(SQLResult *)result
{
    if (_result != result) {
        _result = result;
        [self.table reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.result.results.count ?: 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.result.results.count) {
        NSDictionary *dict = self.result.results[section];
        return dict.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SQLResultCellContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];

    if (self.result.results.count) {
        NSDictionary *dict = self.result.results[indexPath.section];
        NSString *key = [dict.allKeys sortedArrayUsingSelector:@selector(compare:)][indexPath.row];
        id value = dict[key];
        cell.keyLabel.text = key;
        cell.valueLabel.text = [value description];
    } else {
        if (self.result.result) {
            cell.keyLabel.text = @"Success:";
            cell.valueLabel.text = @"";
        } else {
            cell.keyLabel.text = @"Error:";
            cell.valueLabel.text = @"Not Found";
        }
    }

    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = tableView.bounds;
    frame.size.height = 1;
    frame.size.width = 30;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

@end

@interface InteractiveSQLViewController () <TextInputToolbarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation InteractiveSQLViewController
{
    __weak IBOutlet NSLayoutConstraint *_keyboardHeightConstraint;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.dataSource = @[].mutableCopy;

    [self.textView becomeFirstResponder];
    self.textView.inputAccessoryView = ({

        (UIView *)nil;
    });

    __weak typeof(self) wself = self;
    __weak typeof(_keyboardHeightConstraint) keyboardHeightConstraint = _keyboardHeightConstraint;

    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        CGFloat height = wself.view.frame.size.height - keyboardFrameInView.origin.y;
        [UIView animateWithDuration:0.2
                         animations:^{
                             keyboardHeightConstraint.constant = height;
                         }];
        [wself.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)toolbar:(TextInputToolbar *)toolbar didEndEditing:(NSString *)text
{
    __block typeof(text) _text = text;
    if ([text isEqualToString:@"create;"]) {
        Person *p = [Person new];
        p.name = @"test";
        [p save];
//        [ObjectiveRecord beginTransaction:^BOOL{
//            return NO;
//        }];
        return;
    }
    if ([text isEqualToString:@"list;"]) {
        NSLog(@"%@", Select(nil).from([Person class]).orderBy(@"id DESC").execute());
        return;
    }
    [[ObjectiveRecord defaultQueue] inDatabase:^(FMDatabase *db) {
        SQLResult *result;
        if ([[_text lowercaseString] hasPrefix:@"select"]
            || [[_text lowercaseString] hasPrefix:@"."]) {
            if ([[_text lowercaseString] isEqualToString:@".tables;"]) {
                _text = @"select * from sqlite_master;";
            }
            FMResultSet *cursor = [db executeQuery:_text];

            result = [SQLResult empty];
            while (cursor.next) {
                [result.results addObject:cursor.resultDictionary];
            }
            result.result = result.results.count > 0;
        } else {
            result = [SQLResult new];
            result.result = [db executeUpdate:_text];
        }
        result.text = text;

        [self.dataSource addObject:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.dataSource.count - 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
        });
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SQLResultCell height:self.dataSource[indexPath.section]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UINib *nib = [UINib nibWithNibName:@"HeaderView" bundle:nil];
    HeaderView *view = [nib instantiateWithOwner:nil options:nil][0];
    SQLResult *result = self.dataSource[section];
    view.sqlTextLabel.text = [result.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SQLResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];

    SQLResult *result = self.dataSource[indexPath.section];
    cell.result = result;

    return cell;
}

@end
