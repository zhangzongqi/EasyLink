//
//  TabBarViewController.m
//  EasyLink
//
//  Created by 琦琦 on 16/10/9.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 修改tabbar背景色
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:94/255.0 green:83/255.0 blue:223/255.0 alpha:1.0];
    backView.frame = self.tabBar.bounds;
    [[UITabBar appearance] insertSubview:backView atIndex:0];
    
//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:94/255.0 green:83/255.0 blue:223/255.0 alpha:1.0]];
    
    // 设置tabbar是否透明
//    [UITabBar appearance].translucent = NO;
    
//    [[UITabBar appearance] setBackgroundImage:[UIColor colorWithRed:89/255.0 green:77/255.0 blue:222/255.0 alpha:1.0]];
    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FUIColorFromRGB(0xffffff), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
//    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FUIColorFromRGB(0xb1a6ff), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    // 自定义tabbar上字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       FUIColorFromRGB(0xb1a6ff), UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = FUIColorFromRGB(0xffffff);
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
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
