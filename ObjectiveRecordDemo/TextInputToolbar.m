//
//  TextInputToolbar.m
//  ObjectiveRecordDemo
//
//  Created by 林 達也 on 2014/01/03.
//  Copyright (c) 2014年 林 達也. All rights reserved.
//

#import "TextInputToolbar.h"

@interface TextInputToolbar () <UITextViewDelegate>

@end

@implementation TextInputToolbar
{
    __weak IBOutlet NSLayoutConstraint *_toolBarHeightConstraint;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];

    UIEdgeInsets inset = self.textView.textContainerInset;
    inset.left = 5;
    inset.right = 5;
    self.textView.textContainerInset = inset;
    self.textView.layer.cornerRadius = 12;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;

    [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _toolBarHeightConstraint.constant = 11 + _textView.contentSize.height;

    [self layoutIfNeeded];

    CGRect frame = _textView.frame;
    frame.origin.y = 6;
    frame.size.height = _textView.contentSize.height;
    _textView.superview.frame = frame;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length == 0 && [text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    BOOL colon = [textView.text hasSuffix:@";"];
    if (colon && [text isEqualToString:@"\n"]) {
        if ([self.textDelegate respondsToSelector:@selector(toolbar:didEndEditing:)]) {
            [self.textDelegate toolbar:self didEndEditing:textView.text];
            textView.text = @"";
        }
        return NO;
    }
    return YES;
}

@end
