//
//  SKTextField.h
//  TuShou
//
//  Created by Garry on 15/6/22.
//  Copyright (c) 2015年 LifeFun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTextField : UITextField
@property (nonatomic, copy) void (^backward)(void);
@property (nonatomic, copy) void (^didReturn)(NSString *text);
@property (nonatomic, copy) void (^didEditing)(void);
@end
