//
//  ViewController.m
//  TLTag
//
//  Created by Garry on 15/10/28.
//  Copyright © 2015年 FAN LING. All rights reserved.
//

#import "ViewController.h"
#import "TLTagView.h"

@interface ViewController ()
@end

@implementation ViewController
{
    TLTagView *_tagView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tagView = [[TLTagView alloc] initWithFrame:CGRectMake(0, 100, 200, 200) tags:@[@"啊",@"而额外人啊啊啊",@"啊而温柔啊啊",@"啊啊诶菲尔啊",@"啊啊认为啊",@"啊啊啊",@"啊啊啊"] mode:TLTagModeMultiLine];
    //编辑模式不可点击
    _tagView.canEdit = YES;
    _tagView.canBlankInsertTag = YES;
    _tagView.didClickTag = ^(NSString *tag){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tag message:nil delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
        [alert show];
    };
    [_tagView.enterTextfield becomeFirstResponder];
    [self.view addSubview:_tagView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
