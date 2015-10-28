//
//  TLTag.h
//  TLTag
//
//  Created by Garry on 15/10/28.
//  Copyright © 2015年 FAN LING. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  NS_ENUM(NSUInteger,TLTagMode){
    TLTagModeDisplay,
    TLTagModeEdit,
};
@interface TLTag : UIView
-(instancetype)initWithTags:(NSArray *)tags mode:(TLTagMode)mode;
-(instancetype)initWithFrame:(CGRect)frame tags:(NSArray *)tags mode:(TLTagMode)mode;
@property(nonatomic,copy)void (^didClickTag)(NSString *tag);
@end
