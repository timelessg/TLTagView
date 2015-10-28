//
//  ViewController.m
//  TLTag
//
//  Created by Garry on 15/10/28.
//  Copyright © 2015年 FAN LING. All rights reserved.
//

#import "ViewController.h"
#import "TLTag.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TLTag *tagView = [[TLTag alloc] initWithFrame:CGRectMake(0, 100, 200, 200) tags:@[@"啊",@"而额外人啊啊啊",@"啊而温柔啊啊",@"啊啊诶菲尔啊",@"啊啊认为啊",@"啊啊啊",@"啊啊啊"] mode:TLTagModeEdit];
//    TLTag *tagView = [[TLTag alloc] initWithFrame:CGRectMake(0, 100, 200, 200) tags:@[@"啊",@"而额外人啊啊啊",@"啊而温柔啊啊",@"啊啊诶菲尔啊",@"啊啊认为啊",@"啊啊啊",@"啊啊啊"]];
    [self.view addSubview:tagView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
