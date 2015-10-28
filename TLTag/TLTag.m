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
@property(nonatomic,strong)NSMutableArray *tagViews;
@property(nonatomic,assign)TLTagMode mode;

@property(nonatomic,strong)TLTextField *enterTextfield;
@property(nonatomic,strong)UIView *selectedTagView;
@end

@implementation TLTag


-(instancetype)initWithTags:(NSArray *)tags mode:(TLTagMode)mode
{
    if (self = [super init])
    {
        self.tags = [tags mutableCopy];
        self.mode = mode;
        [self setupTags];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame tags:(NSArray *)tags mode:(TLTagMode)mode
{
    if (self = [super initWithFrame:frame])
    {
        self.tags = [tags mutableCopy];
        self.mode = mode;
        [self setupTags];
    }
    return self;
}
-(void)setupTags
{
    self.tagViews = [@[] mutableCopy];
    UIView *lastTagView = nil;
    CGFloat tagsWidth = 0;
    CGFloat tagsHeight = 0;
    NSUInteger lineCount = 0;
    NSUInteger tmpLineCount = 0;
    BOOL isBreak = NO;
    for (int i = 0; i < self.tags.count; i ++) {
        UIView *tagView = [self tagWithText:self.tags[i]];
        [self addSubview:tagView];
        [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastTagView)
            {
                if (isBreak)
                {
                    make.left.equalTo(self.mas_left).offset(0);
                }else
                {
                    make.left.equalTo(lastTagView.mas_right).offset(5);
                }
                make.top.equalTo(self.mas_top).offset((lineCount) * (tagsHeight + 5));
            }else
            {
                make.left.equalTo(self.mas_left).offset(0);
                make.top.equalTo(self.mas_top).offset(0);
            }
        }];
        [tagView layoutIfNeeded];
        tagsWidth += tagView.bounds.size.width + 5;
        tagsHeight = tagView.bounds.size.height;
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
        lastTagView = tagView;
        [self.tagViews addObject:tagView];
    }
    if (self.mode == TLTagModeEdit)
    {
        self.enterTextfield = [[TLTextField alloc] init];
        self.enterTextfield.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.enterTextfield];
        [self.enterTextfield mas_makeConstraints:^(MASConstraintMaker *make)
        {
            if (lastTagView)
            {
                make.left.mas_equalTo(lastTagView.mas_right).offset(5);
                make.top.mas_equalTo(lastTagView.mas_top).offset(0);
                make.height.equalTo(lastTagView.mas_height);
            }else
            {
                make.left.equalTo(self.mas_left).offset(0);
                make.top.equalTo(self.mas_top).offset(0);
                make.height.mas_equalTo(@30);
            }
            make.width.mas_equalTo(self.frame.size.width / 2);
        }];
        WS(weakSelf);
        self.enterTextfield.backward = ^(){
            if ([weakSelf.enterTextfield.text isEqualToString:@""])
            {
                [[weakSelf getLastTagView] removeFromSuperview];
                [weakSelf.tagViews removeLastObject];
                [weakSelf reLayoutTextField];
            }
        };
        self.enterTextfield.didReturn = ^(NSString *text){
            [weakSelf insterTagWith:text];
        };
    }
}
-(UIView *)tagWithText:(NSString *)text
{
    UIView *tagView = [[UIView alloc] init];
    tagView.userInteractionEnabled = YES;
    tagView.backgroundColor = [UIColor blackColor];
    tagView.layer.masksToBounds = YES;
    tagView.layer.cornerRadius = 5;
    [self addSubview:tagView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTag:)];
    [tagView addGestureRecognizer:tap];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.text = text;
    [tagView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    return tagView;
}
-(void)reLayoutTextField
{
    UIView *lastTagView = [self getLastTagView];
    [self.enterTextfield mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (lastTagView)
        {
            make.left.mas_equalTo(lastTagView.mas_right).offset(5);
            make.top.mas_equalTo(lastTagView.mas_top).offset(0);
            make.height.equalTo(lastTagView.mas_height);
        }else
        {
            make.left.equalTo(self.mas_left).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.height.mas_equalTo(@30);
        }
        make.width.mas_equalTo(self.frame.size.width / 2);
    }];
}
-(void)clickTag:(UITapGestureRecognizer *)sender
{
    self.selectedTagView = sender.view;
    self.selectedTagView.backgroundColor = [UIColor redColor];
}
-(void)insterTagWith:(NSString *)tag
{
    UIView *lastView = [self getLastTagView];
    UIView *tagView = [self tagWithText:tag];
    [self addSubview:tagView];
    [tagView mas_updateConstraints:^(MASConstraintMaker *make) {
        
    }];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (lastView) {
            make.left.equalTo(lastView.mas_right).offset(5);
            make.centerY.equalTo(lastView.mas_centerY).offset(0);
        }else{
            make.left.equalTo(self.mas_left).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }
    }];
    self.enterTextfield.text = @"";
    [self.tagViews addObject:tagView];
    [self reLayoutTextField];
}
-(UIView *)getLastTagView{
    return [self.tagViews lastObject];
}
@end
