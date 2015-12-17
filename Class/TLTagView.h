//
//  TLTagView.h
//  TLTagView
//
//  Created by 郭锐 on 15/12/17.
//  Copyright © 2015年 Garry. All rights reserved.
//

#import <UIKit/UIKit.h>

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
@property(nonatomic,copy)void (^didClick)(TLTagButton *);
-(instancetype)initWithTag:(TLTag *)tag;
+(instancetype)buttonWithTag:(TLTag *)tag;
@end

@interface TLTagView : UIView
@property(nonatomic,assign)UIEdgeInsets padding;
@property(nonatomic,assign)CGFloat lineSpacing;
@property(nonatomic,assign)CGFloat itemSpacing;
@property(nonatomic,assign)CGFloat maxLayoutWidth;

@property(nonatomic,assign)BOOL canEdit;

//这里可以传TLTag && String && nil
-(instancetype)initWithTags:(NSArray *)tags Type:(TLTagType)type didClickTag:(DidClickTag)block;
-(void)insertTag:(TLTag *)tag;
@end
