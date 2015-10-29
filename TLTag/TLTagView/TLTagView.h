//
//  TLTag.h
//  TLTag
//
//  Created by Garry on 15/10/28.
//  Copyright © 2015年 FAN LING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTextField.h"


typedef NS_ENUM(NSUInteger,TLTagMode){
    TLTagModeMultiLine = 1,
    TLTagModeSingleLine,
};

@interface TLButton : UIButton

@end

@interface TLTagView : UIView
@property (nonatomic, assign) BOOL           canEdit;
//空格添加Tag
@property (nonatomic, assign) BOOL           canBlankInsertTag;

@property (nonatomic, strong) TLTextField    *enterTextfield;
@property (nonatomic, strong) NSMutableArray *tags;

-(instancetype)initWithTags:(NSArray *)tags mode:(TLTagMode)mode;
-(instancetype)initWithFrame:(CGRect)frame tags:(NSArray *)tags mode:(TLTagMode)mode;

-(void)insterTag:(NSString *)tag;
//点击回调
@property(nonatomic,copy)void (^didClickTag)(NSString *);
@end
