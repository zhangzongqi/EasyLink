//
//  AppDelegate.h
//  EasyLink
//
//  Created by 琦琦 on 16/9/12.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h" // 左边抽屉效果
#import "TabBarViewController.h" // 底边栏基类

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) TabBarViewController *mainTabbarController;

@end

