//
//  TLTextField.h
//  TLTagView
//
//  Created by 郭锐 on 15/12/17.
//  Copyright © 2015年 Garry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTextField : UITextField
@property (nonatomic, copy) void (^backward)(void);
@property (nonatomic, copy) void (^didReturn)(NSString *);
@property (nonatomic, copy) void (^didEditing)(id);
@property (nonatomic, copy) void (^didEnterBlank)(NSString *,NSString *);
@end
