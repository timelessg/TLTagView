//
//  TLTextField.m
//  TLTagView
//
//  Created by 郭锐 on 15/12/17.
//  Copyright © 2015年 Garry. All rights reserved.
//

#import "TLTextField.h"
#import "TLTagView.h"

@interface TLTextField () <UITextFieldDelegate>

@end

@implementation TLTextField
-(instancetype)init{
    if (self = [super init]) {
        self.delegate = self;
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addTarget:self action:@selector(textField:shouldChangeCharactersInRange:replacementString:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
-(void)deleteBackward{
    self.backward();
    [super deleteBackward];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.didReturn) self.didReturn(textField.text);
    textField.text = @"";
    return YES;
}
- (void)textFieldDidChange:(UITextField *)TextField
{
    [self invalidateIntrinsicContentSize];
    if (self.didEditing) self.didEditing();
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "] && [textField.text isEqualToString:@" "])
    {
        textField.text = nil;
        return NO;
    }
    if (self.didEnterBlank) self.didEnterBlank(string,textField.text);
    return YES;
}
@end
