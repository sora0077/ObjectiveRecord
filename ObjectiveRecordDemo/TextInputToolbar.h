//
//  TextInputToolbar.h
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2014/01/03.
//  Copyright (c) 2014年 林 達也. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextInputToolbar;
@protocol TextInputToolbarDelegate <NSObject>

- (void)toolbar:(TextInputToolbar *)toolbar didEndEditing:(NSString *)text;

@end

@interface TextInputToolbar : UIToolbar
@property (weak, nonatomic) IBOutlet id<TextInputToolbarDelegate> textDelegate;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
