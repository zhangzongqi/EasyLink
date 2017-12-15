//
//  GroupViewController.h
//  EasyLink
//
//  Created by 琦琦 on 17/1/16.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSDropDownMenu.h" // 下拉选择器

@interface GroupViewController : UIViewController

@property (nonatomic, copy) UITextField * tfForSearch; // 搜索文本框

@property (nonatomic, copy) JSDropDownMenu *dropDownMenu; // 下拉选择器
@property (nonatomic, assign) NSInteger currentData1Index;
@property (nonatomic, assign) NSInteger currentData2Index;
@property (nonatomic, assign) NSInteger currentData3Index;
@property (nonatomic, assign) NSInteger currentData3SelectedIndex;

// 点击搜索触发事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

// 根据分类页传回数值进行请求列表
- (void) reloadListWithItem:(NSInteger) categoryNum;


@end
