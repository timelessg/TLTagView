//
//  TLTag.m
//  TLTag
//
//  Created by Garry on 15/10/28.
//  Copyright © 2015年 FAN LING. All rights reserved.
//

#import "TLTag.h"
#import <Masonry.h>
#import "TLTextField.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface TLTag ()
@property(nonatomic,strong)NSMutableArray *tags;
@property(nonatomic,strong)NSMutableArray *tagButtons;
@property(nonatomic,assign)TLTagMode mode;

@property(nonatomic,strong)TLTextField *enterTextfield;
@end

@implementation TLTag


-(instancetype)initWithTags:(NSArray *)tags mode:(TLTagMode)mode
{
    if (self = [super init])
    {
        self.tags = [tags mutableCopy];
        self.mode = mode;
        [self initTagsView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame tags:(NSArray *)tags mode:(TLTagMode)mode
{
    if (self = [super initWithFrame:frame])
    {
        self.tags = [tags mutableCopy];
        self.mode = mode;
        [self initTagsView];
    }
    return self;
}
-(void)initTagsView
{
    self.tagButtons = [@[] mutableCopy];
    UIButton *lastTagButton = nil;
    CGFloat tagsWidth = 0;
    NSUInteger lineCount = 0;
    NSUInteger tmpLineCount = 0;
    BOOL isBreak = NO;
    for (int i = 0; i < self.tags.count; i ++) {
        UIButton *tagButton = [self tagButtonWithText:self.tags[i]];
        [self addSubview:tagButton];
        [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastTagButton)
            {
                if (isBreak)
                {
                    make.left.equalTo(self.mas_left).offset(0);
                    make.top.equalTo(lastTagButton.mas_bottom).offset(5);
                }else
                {
                    make.left.equalTo(lastTagButton.mas_right).offset(5);
                    make.top.equalTo(lastTagButton.mas_top).offset(0);
                }
            }else
            {
                make.left.equalTo(self.mas_left).offset(0);
                make.top.equalTo(self.mas_top).offset(0);
            }
        }];
        [tagButton layoutIfNeeded];
        tagsWidth += tagButton.bounds.size.width + 5;
        if (self.frame.size.width < tagsWidth)
        {
            lineCount = (NSUInteger)tagsWidth / self.frame.size.width;
            if (tmpLineCount != lineCount)
            {
                tmpLineCount = lineCount;
                isBreak = YES;
            }else
            {
                isBreak = NO;
            }
        }
        lastTagButton = tagButton;
        [self.tagButtons addObject:tagButton];
    }
    if (self.mode == TLTagModeEdit)
    {
        [self addSubview:self.enterTextfield];
        [self.enterTextfield mas_makeConstraints:^(MASConstraintMaker *make)
         {
             if (lastTagButton)
             {
                 make.left.mas_equalTo(lastTagButton.mas_right).offset(5);
                 make.top.mas_equalTo(lastTagButton.mas_top).offset(0);
                 make.height.equalTo(lastTagButton.mas_height);
             }else
             {
                 make.left.equalTo(self.mas_left).offset(0);
                 make.top.equalTo(self.mas_top).offset(0);
                 make.height.mas_equalTo(@30);
             }
             make.width.mas_equalTo(self.frame.size.width / 2);
         }];
    }
}
-(UIButton *)tagButtonWithText:(NSString *)text
{
    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tagButton.contentEdgeInsets = UIEdgeInsetsMake(1, 5, 1, 5);
    [tagButton setBackgroundColor:[UIColor blackColor]];
    tagButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [tagButton setTitle:text forState:UIControlStateNormal];
    [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tagButton.layer.masksToBounds = YES;
    tagButton.layer.cornerRadius = 5;
    return tagButton;
}
-(void)reLayoutTextField
{
    UIButton *lastTagButton = [self getLastTagButton];
    [self.enterTextfield mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (lastTagButton)
        {
            make.left.mas_equalTo(lastTagButton.mas_right).offset(5);
            make.top.mas_equalTo(lastTagButton.mas_top).offset(0);
            make.height.equalTo(lastTagButton.mas_height);
        }else
        {
            make.left.equalTo(self.mas_left).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.height.mas_equalTo(@30);
        }
        make.width.mas_equalTo(self.frame.size.width / 2);
    }];
}
-(void)clickTag:(UIButton *)sender
{
    
}
-(void)insterTagWith:(NSString *)tag
{
    UIButton *lastTagButton = [self getLastTagButton];
    [lastTagButton layoutIfNeeded];
    CGFloat tagButtonWidth = [tag sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width + 10;
    CGFloat lastTagOffsetX = lastTagButton.bounds.size.width + lastTagButton.frame.origin.x + 5;
    
    UIButton *tagButton = [self tagButtonWithText:tag];
    [self addSubview:tagButton];
    [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (lastTagOffsetX + tagButtonWidth > self.frame.size.width) {
            make.left.equalTo(self.mas_left).offset(0);
            make.top.equalTo(lastTagButton.mas_bottom).offset(5);
        }else{
            if (lastTagButton) {
                make.left.equalTo(lastTagButton.mas_right).offset(5);
                make.top.equalTo(lastTagButton.mas_top).offset(0);
            }else{
                make.left.equalTo(self.mas_left).offset(0);
                make.top.equalTo(self.mas_top).offset(0);
            }
        }
    }];
    self.enterTextfield.text = @"";
    [self.tagButtons addObject:tagButton];
    [self reLayoutTextField];
}
-(TLTextField *)enterTextfield{
    if (!_enterTextfield)
    {
        self.enterTextfield = [[TLTextField alloc] init];
        self.enterTextfield.font = [UIFont systemFontOfSize:12];
        WS(weakSelf);
        self.enterTextfield.backward = ^()
        {
            if ([weakSelf.enterTextfield.text isEqualToString:@""])
            {
                UIButton *lastTagButton = [weakSelf getLastTagButton];
                if (lastTagButton.selected)
                {
                    [[weakSelf getLastTagButton] removeFromSuperview];
                    [weakSelf.tagButtons removeLastObject];
                    [weakSelf reLayoutTextField];
                }else
                {
                    [lastTagButton setBackgroundColor:[UIColor redColor]];
                    lastTagButton.selected = YES;
                }
            }
        };
        self.enterTextfield.didReturn = ^(NSString *text)
        {
            [weakSelf insterTagWith:text];
        };
        self.enterTextfield.didEditing = ^()
        {
            UIButton *lastTagButton = [weakSelf getLastTagButton];
            lastTagButton.selected = NO;
            [lastTagButton setBackgroundColor:[UIColor blackColor]];
        };
        return _enterTextfield;
    }
    return _enterTextfield;
}
-(UIButton *)getLastTagButton{
    return [self.tagButtons lastObject];
}
@end
