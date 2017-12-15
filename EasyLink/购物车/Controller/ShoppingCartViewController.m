//
//  ShoppingCartViewController.m
//  EasyLink
//
//  Created by 琦琦 on 17/1/16.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "ShoppingCartViewController.h"

@interface ShoppingCartViewController ()

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景色
    self.view.backgroundColor = FUIColorFromRGB(0xffffff);
    
    // 设置导航条不透明
    self.navigationController.navigationBar.translucent = NO;
    
    // 设置导航栏标题
    UILabel *lbItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    lbItemTitle.text = @"购物车";
    lbItemTitle.textColor = [UIColor whiteColor];
    lbItemTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lbItemTitle;
}

// 页面将要显示
- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    // 设置导航栏背景色(用到了UIImage+GradientColor.h这个类扩展)
    UIColor *topleftColor1 = FUIColorFromRGB(0x9080ff);
    UIColor *bottomColor1 = FUIColorFromRGB(0x7d6dfa);
    UIImage *bgImg1 = [UIImage gradientColorImageFromColors:@[topleftColor1, bottomColor1] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(W, 64)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:bgImg1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
