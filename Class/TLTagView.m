//
//  TLTagView.m
//  TLTagView
//
//  Created by 郭锐 on 15/12/17.
//  Copyright © 2015年 Garry. All rights reserved.
//

#import "TLTagView.h"
#import "UIColor+Hex.h"
#import <Masonry.h>

#define kTLTextFieldWith 100

#define SMAS(x) [self.tagConstraints addObject:x]

@implementation TLTag
+(instancetype)tag:(NSString *)text{
    TLTag *tag = [TLTag new];
    tag.tag = text;
    tag.tagBackgroundNormalColor = [UIColor colorWithHex:0xFFE3E3E3];
    tag.tagBackgroundSelectedColor = [UIColor colorWithHex:0xFFAF9D83];
    tag.tagNormalColor = [UIColor colorWithHex:0xFF333333];
    tag.tagSelectedColor = [UIColor colorWithHex:0xFFFFFFFF];
    tag.tagFont = [UIFont systemFontOfSize:14];
    tag.tagCornerRadius = 8.0f;
    tag.enable = YES;
    return tag;
}
@end

@implementation TLTagButton

-(instancetype)initWithTag:(TLTag *)tag{
    if (self = [super init]) {
        _tlTag = tag;
        self.backgroundColor = tag.tagBackgroundNormalColor;
        if (_tlTag.tagBgImageNamed) [self setBackgroundImage:[UIImage imageNamed:_tlTag.tagBgImageNamed] forState:UIControlStateNormal];
        [self setTitle:_tlTag.tag forState:UIControlStateNormal];
        [self setTitleColor:_tlTag.tagNormalColor forState:UIControlStateNormal];
        [self setTitleColor:_tlTag.tagSelectedColor  forState:UIControlStateSelected];
        self.layer.borderColor = _tlTag.tagBorderColor.CGColor;
        self.layer.borderWidth = _tlTag.tagBorderWidth;
        self.titleLabel.font = _tlTag.tagFont;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = _tlTag.tagCornerRadius;
        self.enabled = _tlTag.enable;
        self.contentEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 5);
        [self setContentHuggingPriority:UILayoutPriorityRequired
                                forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired
                                              forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    return self;
}
+(instancetype)buttonWithTag:(TLTag *)tag{
    return [[TLTagButton alloc] initWithTag:tag];
}
@end

@interface TLTagView ()
@property(nonatomic,strong)NSMutableArray *tagConstraints;
@property(nonatomic,strong)NSMutableArray *tagArray;

@end
@implementation TLTagView
{
    DidClickTag _block;
    TLTagType _type;
    
    UIView *_lastTag;
    
    UIView *_selectedTag;
    
    CGFloat _inputTextWidth;
    CGFloat _inputTextFieldWidth;
    
    BOOL _needBreakLine;
    
    BOOL _isDidSetup;
}
-(instancetype)initWithTags:(NSArray *)tags Type:(TLTagType)type didClickTag:(DidClickTag)block{
    if (self = [super init]) {
        _block = block;
        _type = type;
        self.tagArray = [tags mutableCopy];
        for (TLTag *tag in self.tagArray) {
            [self addTag:tag];
        }
        [self addSubview:self.inputTagTextField];
        [self.inputTagTextField becomeFirstResponder];
    }
    return self;
}
//计算内容size
-(CGSize)intrinsicContentSize{
    if (!self.tagArray.count) {
        return CGSizeZero;
    }
    CGFloat currentX = self.padding.left;
    
    CGFloat totalHeight = self.padding.top;
    CGFloat totalWidth = self.padding.left;
    
    UIView *lastView = nil;
    if (_type == TLTagTypeMultiLine && self.maxLayoutWidth > 0) {
        int lineCount = 0;
        for (UIView *subview in self.subviews) {
            CGFloat subview_width = subview.intrinsicContentSize.width;
            CGFloat subview_height = subview.intrinsicContentSize.height;
            if (lastView) {
                if (self.padding.left + subview_width >= self.maxLayoutWidth) {
                    lineCount ++ ;
                    currentX = self.padding.left;
                    totalHeight += subview_height;
                }else{
                    currentX += subview_width;
                }
            }else{
                lineCount ++ ;
                totalHeight += subview_height;
                currentX += subview_width;
            }
            lastView = subview;
        }
        totalHeight += self.padding.bottom + (lineCount - 1) * self.lineSpacing;
        totalWidth = (lineCount >= 1) ? self.maxLayoutWidth : MIN(self.maxLayoutWidth, totalWidth);
    }else{
        for (TLTagButton *btn in self.subviews) {
            CGFloat btn_width = btn.intrinsicContentSize.width;
            currentX += btn_width;
        }
        totalHeight += ((UIView *)[self.subviews lastObject]).intrinsicContentSize.height + self.padding.bottom;
        totalWidth = currentX + (self.subviews.count - 1) * self.itemSpacing + self.padding.right;
    }
    return CGSizeMake(totalWidth, totalHeight);
}
//重新布局
-(void)updateConstraints{
    [super updateConstraints];
    
    if (_isDidSetup) {
        return;
    }
    
    for (MASConstraint *constranit in self.tagConstraints) {
        [constranit uninstall];
    }
    [self.tagConstraints removeAllObjects];
    
    _lastTag = nil;
    
    CGFloat currentX = self.padding.left;
    
    if (_type == TLTagTypeMultiLine) {
        NSLog(@"%@",self.subviews);
        for (UIView *subview in self.subviews) {
            CGFloat subview_width = subview.intrinsicContentSize.width;
            
            NSLog(@"%@",[NSValue valueWithCGSize:subview.intrinsicContentSize]);
            [subview mas_makeConstraints:^(MASConstraintMaker *make) {
                SMAS(make.trailing.lessThanOrEqualTo(self.mas_trailing).offset(-self.padding.right));
            }];
            if (_lastTag) {
                if ([subview isKindOfClass:[TLTagButton class]]) {
                    if (currentX + subview_width + self.padding.right > self.maxLayoutWidth) {
                        [subview mas_makeConstraints:^(MASConstraintMaker *make) {
                            SMAS(make.leading.equalTo(self.mas_leading).offset(self.padding.left));
                            SMAS(make.top.equalTo(_lastTag.mas_bottom).offset(self.lineSpacing));
                        }];
                        currentX = self.padding.left + subview_width;
                    }else{
                        [subview mas_makeConstraints:^(MASConstraintMaker *make) {
                            SMAS(make.leading.equalTo(_lastTag.mas_trailing).offset(self.itemSpacing));
                            SMAS(make.centerY.equalTo(_lastTag.mas_centerY).offset(0));
                        }];
                        currentX += subview_width;
                    }
                }else{
                    [self.inputTagTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                        SMAS(make.centerY.equalTo([self lastTag].mas_centerY).offset(0));
                        SMAS(make.left.equalTo([self lastTag].mas_right).offset(self.itemSpacing));
                        SMAS(make.bottom.equalTo(self.mas_bottom).with.offset(-self.padding.bottom));
                        SMAS(make.height.mas_equalTo(21));
                    }];
                }
            }else{
                if ([subview isKindOfClass:[TLTagButton class]]) {
                    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
                        SMAS(make.leading.equalTo(self.mas_leading).offset(self.padding.left));
                        SMAS(make.top.equalTo(self.mas_top).offset(self.padding.top));
                    }];
                    currentX += subview_width;
                }else{
                    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
                        SMAS(make.leading.equalTo(self.mas_leading).offset(self.padding.left));
                        SMAS(make.top.equalTo(self.mas_top).offset(self.padding.top));
                        SMAS(make.bottom.equalTo(self.mas_bottom).offset(-self.padding.bottom));
                    }];
                }
                _lastTag = subview;
            }
            if ([subview isKindOfClass:[TLTagButton class]]) {
                _lastTag = subview;
            }
        }
    }else{
        
    }
    
    [_lastTag mas_makeConstraints:^(MASConstraintMaker *make) {
        SMAS(make.bottom.equalTo(self.mas_bottom).offset(-self.padding.bottom));
    }];
    
    _inputTextFieldWidth = self.maxLayoutWidth - currentX - self.itemSpacing;
    
    _isDidSetup = YES;
}
-(UIView *)lastTag{
    UIView *tmp = nil;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[TLTagButton class]]) {
            tmp = view;
        }
    }
    return tmp;
}
-(void)layoutSubviews{
    if (_type == TLTagTypeMultiLine) {
        self.maxLayoutWidth = self.frame.size.width - self.padding.right - self.padding.left;
    }
    [super layoutSubviews];
}
-(void)addTag:(TLTag *)tag{
    TLTagButton *btn = [TLTagButton buttonWithTag:tag];
    [btn addTarget:self action:@selector(didClickTag:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    _isDidSetup = NO;
    [self invalidateIntrinsicContentSize];
    
}
-(void)insertTag:(TLTag *)tag{
    TLTagButton *btn = [TLTagButton buttonWithTag:tag];
    [btn addTarget:self action:@selector(didClickTag:) forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:btn belowSubview:self.inputTagTextField];
    
    _isDidSetup = NO;
    [self invalidateIntrinsicContentSize];
}
-(void)didClickTag:(TLTagButton *)sender{
    [self resetSelected];
    sender.selected = YES;
    _selectedTag = sender;
    sender.backgroundColor = sender.selected ? sender.tlTag.tagBackgroundSelectedColor : sender.tlTag.tagBackgroundNormalColor;
    [self.inputTagTextField becomeFirstResponder];
}
-(void)deleteTag{
    if ([self.inputTagTextField.text isEqualToString:@""]) {
        if (_selectedTag) {
            [_selectedTag removeFromSuperview];
            _selectedTag = nil;
        }else{
            TLTagButton *lastTag = (TLTagButton *)[self lastTag];
            lastTag.selected = YES;
            lastTag.backgroundColor = lastTag.tlTag.tagBackgroundSelectedColor;
            _selectedTag = lastTag;
        }
        
        _isDidSetup = NO;
        [self setNeedsUpdateConstraints];
    }
}
-(void)setMaxLayoutWidth:(CGFloat)maxLayoutWidth{
    if (_maxLayoutWidth != maxLayoutWidth) {
        _maxLayoutWidth = maxLayoutWidth;
        _isDidSetup = NO;
        [self setNeedsUpdateConstraints];
    }
}
-(TLTextField *)inputTagTextField{
    if (!_inputTagTextField) {
        __weak typeof(self)weakSelf = self;
        _inputTagTextField = [[TLTextField alloc] init];
        _inputTagTextField.bounds = CGRectMake(0, 0, 100, 30);
        _inputTagTextField.font = [UIFont systemFontOfSize:14];
        [_inputTagTextField setContentHuggingPriority:UILayoutPriorityRequired
                                              forAxis:UILayoutConstraintAxisHorizontal];
        [_inputTagTextField setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                            forAxis:UILayoutConstraintAxisHorizontal];
        //return键 get
        _inputTagTextField.didReturn = ^(NSString *text){
            if (![text isEqualToString:@""]) {
                [weakSelf insertTag:[TLTag tag:text]];
            }
        };
        //退格键 get
        _inputTagTextField.didEnterBlank = ^(NSString *edittingText,NSString *text){
            
        };
        //正在输入 get
        _inputTagTextField.didEditing = ^(){
            [weakSelf resetSelected];
            _isDidSetup = NO;
            [weakSelf invalidateIntrinsicContentSize];
        };
        _inputTagTextField.backward = ^(){
            [weakSelf deleteTag];
        };
    }
    return _inputTagTextField;
}
-(NSArray *)getAllTagByText:(BOOL)byText{
    NSString *tfText = self.inputTagTextField.text;
    if (![tfText isEqualToString:@""]) {
        [self insertTag:[TLTag tag:tfText]];
        self.inputTagTextField.text = @"";
    }
    NSMutableArray *allTags = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[TLTagButton class]]) {
            if (byText) {
                [allTags addObject:((TLTagButton *)view).tlTag.tag];
            }else{
                [allTags addObject:((TLTagButton *)view).tlTag];
            }
        }
    }
    return [allTags copy];
}
-(void)resetSelected{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[TLTagButton class]]) {
            TLTagButton *tag = (TLTagButton *)view;
            tag.selected = NO;
            tag.backgroundColor = tag.tlTag.tagBackgroundNormalColor;
        }
    }
    _selectedTag = nil;
}
-(NSMutableArray *)tagConstraints{
    if (!_tagConstraints) {
        _tagConstraints = [NSMutableArray array];
    }
    return _tagConstraints;
}
@end
