//
//  TLTag.m
//  TLTag
//
//  Created by Garry on 15/10/28.
//  Copyright © 2015年 FAN LING. All rights reserved.
//

#import "TLTagView.h"
#import <Masonry.h>
#import "TLTextField.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface TLTagView ()
@property(nonatomic, strong)NSMutableArray *tags;
@property(nonatomic, strong)NSMutableArray *tagButtons;
@property(nonatomic, assign)TLTagMode      mode;

@property(nonatomic, strong)TLTextField    *enterTextfield;
@property(nonatomic, strong)UIScrollView   *tagScrollView;

@property(nonatomic, strong)void (^textFieldMasConstraintMaker)(MASConstraintMaker *);
@end

@implementation TLTagView


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
    UIButton *lastTagButton = nil;
    CGFloat tagsWidth = 0;
    NSUInteger lineCount = 0;
    NSUInteger tmpLineCount = 0;
    BOOL isBreak = NO;
    for (int i = 0; i < self.tags.count; i ++) {
        UIButton *tagButton = [self tagButtonWithText:self.tags[i]];
        if (self.mode == TLTagModeMultiLine) {
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
        }
        if (self.mode == TLTagModeSingleLine) {
            [self addSubview:self.tagScrollView];
            [self.tagScrollView addSubview:tagButton];
            [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastTagButton) {
                    if (i == self.tags.count - 1) {
                        make.right.equalTo(self.tagScrollView.mas_right).offset(0);
                    }
                    make.left.equalTo(lastTagButton.mas_right).offset(5);
                    make.centerY.equalTo(lastTagButton.mas_centerY).offset(0);
                }else{
                    make.left.equalTo(self.tagScrollView.mas_left).offset(0);
                    make.top.equalTo(self.tagScrollView.mas_top).offset(0);
                }
            }];
        }
        lastTagButton = tagButton;
        [self.tagButtons addObject:tagButton];
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
    [self.enterTextfield mas_remakeConstraints:self.textFieldMasConstraintMaker];
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
-(UIScrollView *)tagScrollView
{
    if (!_tagScrollView)
    {
        self.tagScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.tagScrollView.autoresizesSubviews = YES;
        self.tagScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _tagScrollView;
}
-(UIButton *)getLastTagButton
{
    return [self.tagButtons lastObject];
}
-(void)setCanEdit:(BOOL)canEdit
{
    CGFloat tagButtonHeight = [@"啊啊" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].height;
    if ((self.mode == TLTagModeMultiLine) && canEdit) {
        [self addSubview:self.enterTextfield];
        WS(weakSelf);
        self.textFieldMasConstraintMaker = ^(MASConstraintMaker *make){
            UIButton *lastTagButton = [weakSelf getLastTagButton];
            if (lastTagButton)
            {
                make.left.mas_equalTo(lastTagButton.mas_right).offset(5);
                make.top.mas_equalTo(lastTagButton.mas_top).offset(0);
                make.height.equalTo(lastTagButton.mas_height);
            }else
            {
                make.left.equalTo(weakSelf.mas_left).offset(0);
                make.top.equalTo(weakSelf.mas_top).offset(0);
                make.height.mas_equalTo(tagButtonHeight);
            }
            make.width.mas_equalTo(self.frame.size.width / 2);
        };
        [self.enterTextfield mas_makeConstraints:self.textFieldMasConstraintMaker];
    }
}
-(NSMutableArray *)tagButtons{
    if (!_tagButtons) {
        _tagButtons = [@[] mutableCopy];
    }
    return _tagButtons;
}
@end
