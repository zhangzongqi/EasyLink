//
//  SelectCityView.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/1.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCityView : UIView

@property (nonatomic, copy) UIButton *closeBtn; // 关闭按钮
@property (nonatomic, copy) UILabel *tipSelect; // 选择城市提示语
@property (nonatomic, copy) UITableView *citytableView; // 城市选择tableView

// 创建frame
- (id)initWithFrame:(CGRect)frame;

@end
