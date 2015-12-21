//
//  ViewController.m
//  TLTagView
//
//  Created by 郭锐 on 15/12/17.
//  Copyright © 2015年 Garry. All rights reserved.
//

#import "ViewController.h"
#import "TLTagView.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TLTagView *view = [[TLTagView alloc] initWithTags:nil Type:TLTagTypeMultiLine didClickTag:^(NSUInteger index) {
        
    }];
    view.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    view.lineSpacing = 5;
    view.itemSpacing = 5;
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(0);
        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.trailing.equalTo(self.view.mas_trailing).offset(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
