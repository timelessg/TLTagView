//
//  SKTextField.m
//  TuShou
//
//  Created by Garry on 15/6/22.
//  Copyright (c) 2015年 LifeFun. All rights reserved.
//

#import "TLTextField.h"

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
    return YES;
}
- (void) textFieldDidChange:(UITextField *) TextField
{
    if (self.didEditing) self.didEditing();
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    textField.tintColor = [UIColor blackColor];
    if ([string isEqualToString:@" "]) {
        NSString *text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (self.didEnterBlank) self.didEnterBlank(text);
    }
    return YES;
}
@end
