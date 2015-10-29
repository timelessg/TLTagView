//
//  TLTag.h
//  TLTag
//
//  Created by Garry on 15/10/28.
//  Copyright © 2015年 FAN LING. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,TLTagMode){
    TLTagModeMultiLine = 1,
    TLTagModeSingleLine,
};
@interface TLTagView : UIView
@property(nonatomic,assign) BOOL canEdit;
//字体
@property(nonatomic,strong) UIFont       *tagFont;
//tag内边距
@property(nonatomic,assign) UIEdgeInsets tagContentEdgeInsets;

@property(nonatomic,strong) UIColor      *tagColor;

@property(nonatomic,strong) UIColor      *tagButtonBackgroundColor;


-(instancetype)initWithTags:(NSArray *)tags mode:(TLTagMode)mode;
-(instancetype)initWithFrame:(CGRect)frame tags:(NSArray *)tags mode:(TLTagMode)mode;

@property(nonatomic,copy)void (^didClickTag)(NSString *tag);
@end
