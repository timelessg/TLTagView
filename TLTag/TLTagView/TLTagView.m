//
//  TLTag.m
//  TLTag
//
//  Created by Garry on 15/10/28.
//  Copyright © 2015年 FAN LING. All rights reserved.
//

#import "TLTagView.h"
#import <Masonry.h>

#define WS(weakSelf)         __weak __typeof(&*self)weakSelf = self;
//自定义
#define TLTAGFONT           [UIFont systemFontOfSize:14]
#define TLTAGBGCOLOR        [UIColor blackColor]
#define TLTAGTEXTCOLOR      [UIColor whiteColor]
#define TLTAGSELECTEDCOLOR  [UIColor redColor]
#define TLTAGCORNERRADIUS   5.0f
#define TLTAGEDGEINSETS     UIEdgeInsetsMake(1, 5, 1, 5)

@implementation TLButton
-(instancetype)initWithTag:(NSString *)tag
{
    if (self = [super init])
    {
        self.contentEdgeInsets = TLTAGEDGEINSETS;
        [self setBackgroundColor:TLTAGBGCOLOR];
        self.titleLabel.font = TLTAGFONT;
        [self setTitle:tag forState:UIControlStateNormal];
        [self setTitleColor:TLTAGTEXTCOLOR forState:UIControlStateNormal];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius  = TLTAGCORNERRADIUS;
    }
    return self;
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.backgroundColor = selected ? TLTAGSELECTEDCOLOR : TLTAGBGCOLOR;
}
@end

@interface TLTagView ()
@property (nonatomic, strong)     NSMutableArray *tagButtons;
@property (nonatomic, assign)     TLTagMode      mode;

@property (nonatomic, strong)     UIScrollView   *tagScrollView;
@property (nonatomic, strong)     UIButton *selectedButton;
@property (nonatomic, strong)void (^textFieldMas)(MASConstraintMaker *);
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
    TLButton *lastTagButton = nil;
    CGFloat tagsWidth = 0;
    NSUInteger lineCount = 0;
    NSUInteger tmpLineCount = 0;
    BOOL isBreak = NO;
    for (int i = 0; i < self.tags.count; i ++)
    {
        TLButton *tagButton = [[TLButton alloc] initWithTag:self.tags[i]];
        [tagButton addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
        if (self.mode == TLTagModeMultiLine)
        {
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
        if (self.mode == TLTagModeSingleLine)
        {
            [self addSubview:self.tagScrollView];
            [self.tagScrollView addSubview:tagButton];
            [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastTagButton)
                {
                    if (i == self.tags.count - 1) {
                        make.right.equalTo(self.tagScrollView.mas_right).offset(0);
                    }
                    make.left.equalTo(lastTagButton.mas_right).offset(5);
                    make.centerY.equalTo(lastTagButton.mas_centerY).offset(0);
                }else
                {
                    make.left.equalTo(self.tagScrollView.mas_left).offset(0);
                    make.top.equalTo(self.tagScrollView.mas_top).offset(0);
                }
            }];
        }
        lastTagButton = tagButton;
        [self.tagButtons addObject:tagButton];
    }
}
-(void)reLayoutTextField
{
    [self.enterTextfield mas_remakeConstraints:self.textFieldMas];
}
-(void)clickTag:(UIButton *)sender
{
    if (self.canEdit)
    {
        _selectedButton.selected = NO;
        _selectedButton = sender;
        sender.selected = YES;
    }else
    {
        if (self.didClickTag) self.didClickTag(sender.titleLabel.text);
    }
}
-(void)insterTag:(NSString *)tag
{
    if ([tag isEqualToString:@""]) return;
    UIButton *lastTagButton = [self getLastTagButton];
    [lastTagButton layoutIfNeeded];
    CGFloat tagButtonWidth = [tag sizeWithAttributes:@{NSFontAttributeName:TLTAGFONT}].width + 10;
    CGFloat lastTagOffsetX = lastTagButton.bounds.size.width + lastTagButton.frame.origin.x + 5;
    
    UIButton *tagButton = [[TLButton alloc] initWithTag:tag];
    [tagButton addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tagButton];
    [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (lastTagOffsetX + tagButtonWidth > self.frame.size.width) {
            make.left.equalTo(self.mas_left).offset(0);
            make.top.equalTo(lastTagButton.mas_bottom).offset(5);
        }else
        {
            if (lastTagButton) {
                make.left.equalTo(lastTagButton.mas_right).offset(5);
                make.top.equalTo(lastTagButton.mas_top).offset(0);
            }else{
                make.left.equalTo(self.mas_left).offset(0);
                make.top.equalTo(self.mas_top).offset(0);
            }
        }
    }];
    self.enterTextfield.text = nil;
    [self.tagButtons addObject:tagButton];
    [self reLayoutTextField];
}
-(void)removeTagWitgIndex:(NSUInteger)index
{
    [self.tagButtons[index] removeFromSuperview];
    [self.tagButtons removeObjectAtIndex:index];
    [self reLayoutTextField];
}
-(TLTextField *)enterTextfield
{
    if (!_enterTextfield)
    {
        self.enterTextfield = [[TLTextField alloc] init];
        self.enterTextfield.font = TLTAGFONT;
        WS(weakSelf);
        self.enterTextfield.backward = ^()
        {
            if ([weakSelf.enterTextfield.text isEqualToString:@""])
            {
                if (weakSelf.selectedButton.selected) {
                    [weakSelf removeTag];
                }else{
                    weakSelf.selectedButton = [weakSelf getLastTagButton];
                    weakSelf.selectedButton.selected = YES;
                }
            }
        };
        self.enterTextfield.didReturn = ^(NSString *text)
        {
            [weakSelf insterTag:text];
        };
        self.enterTextfield.didEditing = ^()
        {
            UIButton *lastTagButton = [weakSelf getLastTagButton];
            lastTagButton.selected = NO;
            [lastTagButton setBackgroundColor:TLTAGBGCOLOR];
        };
        self.enterTextfield.didEnterBlank = ^(NSString *editingText,NSString *text)
        {
            if (weakSelf.canBlankInsertTag) {
                if ([editingText isEqualToString:@" "]) {
                    [weakSelf insterTag:[text stringByReplacingOccurrencesOfString:@" " withString:@""]];
                }
            }
            weakSelf.selectedButton.selected = NO;
            weakSelf.selectedButton = nil;
        };
        return _enterTextfield;
    }
    return _enterTextfield;
}
-(void)removeTag{
    if (_selectedButton)
    {
        NSUInteger index = [self.tagButtons indexOfObject:_selectedButton];
        if (index == 0 && self.tagButtons.count != 1) {
            TLButton *nextButton = self.tagButtons[index + 1];
            [nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(0);
                make.top.equalTo(self.mas_top).offset(0);
            }];
        }else if (index == self.tagButtons.count - 1){
            
        }else{
            TLButton *nextButton = self.tagButtons[index + 1];
            TLButton *lastButton = self.tagButtons[index - 1];
            [nextButton layoutIfNeeded];
            [lastButton layoutIfNeeded];
            CGFloat nextButtonOffsetX = nextButton.frame.origin.x + nextButton.frame.size.width;
            CGFloat lastButtonWidth = lastButton.frame.size.width;
            [nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (self.frame.size.width < nextButtonOffsetX + lastButtonWidth) {
                    make.left.equalTo(self.mas_left).offset(0);
                    make.top.equalTo(lastButton.mas_bottom).offset(5);
                }else{
                    make.left.equalTo(lastButton.mas_right).offset(5);
                    make.top.equalTo(lastButton.mas_top).offset(0);
                }
            }];
        }
        [_selectedButton removeFromSuperview];
        [self.tagButtons removeObject:_selectedButton];
        _selectedButton = nil;
        [self reLayoutTextField];
    }
}
-(TLButton *)getLastTagButton
{
    return [self.tagButtons lastObject];
}
-(UIScrollView *)tagScrollView
{
    if (!_tagScrollView)
    {
        _tagScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _tagScrollView.autoresizesSubviews = YES;
        _tagScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _tagScrollView;
}
-(void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
    if ((self.mode == TLTagModeMultiLine) && canEdit)
    {
        [self addSubview:self.enterTextfield];

        [self.enterTextfield mas_makeConstraints:self.textFieldMas];
    }
}
-(void (^)(MASConstraintMaker *))textFieldMas{
    if (!_textFieldMas) {
        WS(weakSelf);
        _textFieldMas = ^(MASConstraintMaker *make)
        {
            CGFloat tagButtonHeight = [@"" sizeWithAttributes:@{NSFontAttributeName:TLTAGFONT}].height;
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
    }
    return _textFieldMas;
}
-(void)setCanBlankInsertTag:(BOOL)canBlankInsertTag
{
    _canBlankInsertTag = canBlankInsertTag;
}
-(NSMutableArray *)tagButtons
{
    if (!_tagButtons)
    {
        _tagButtons = [@[] mutableCopy];
    }
    return _tagButtons;
}
@end
