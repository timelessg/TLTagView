//
//  TLTagView.h
//  TLTagView
//
//  Created by 郭锐 on 15/12/17.
//  Copyright © 2015年 Garry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTextField.h"

typedef NS_ENUM(NSUInteger,TLTagType) {
    TLTagTypeSingleLine,
    TLTagTypeMultiLine,
};

typedef void(^DidClickTag)(NSUInteger );

@interface TLTag : NSObject
@property(nonatomic,copy)NSString *tag;
@property(nonatomic,copy)NSMutableAttributedString *attribute;
@property(nonatomic,copy)UIColor *tagNormalColor;
@property(nonatomic,copy)UIColor *tagSelectedColor;
@property(nonatomic,strong)UIFont *tagFont;

@property(nonatomic,strong)UIColor *tagBorderColor;
@property(nonatomic,assign)CGFloat tagBorderWidth;

@property(nonatomic,copy)NSString *tagBgImageNamed;
@property(nonatomic,strong)UIColor *tagBackgroundNormalColor;
@property(nonatomic,strong)UIColor *tagBackgroundSelectedColor;

@property(nonatomic,assign)CGFloat tagCornerRadius;

@property(nonatomic,assign)BOOL enable;

+(instancetype)tag:(NSString *)text;
@end

@interface TLTagButton : UIButton
@property(nonatomic,strong)TLTag *tlTag;
-(instancetype)initWithTag:(TLTag *)tag;
+(instancetype)buttonWithTag:(TLTag *)tag;
@end

@interface TLTagView : UIView
//边距
@property(nonatomic,assign)UIEdgeInsets padding;
@property(nonatomic,assign)CGFloat lineSpacing;
@property(nonatomic,assign)CGFloat itemSpacing;
@property(nonatomic,assign)CGFloat maxLayoutWidth;
@property(nonatomic,strong)TLTextField *inputTagTextField;
//限制输入Tag数
@property(nonatomic,assign)NSUInteger maxTagCount;
//超过Tag最大限制后的回调
@property(nonatomic,copy)void (^tagMax)();

@property(nonatomic,assign)BOOL canEdit;

//这里可以传TLTag && String && nil
-(instancetype)initWithTags:(NSArray *)tags Type:(TLTagType)type didClickTag:(DidClickTag)block;
//插入tag
-(void)insertTag:(TLTag *)tag;
//byText：YES 返回一个字符串数组
//byText：NO 返回一个TLTag数组
-(NSArray *)getAllTagByText:(BOOL)byText;
@end
