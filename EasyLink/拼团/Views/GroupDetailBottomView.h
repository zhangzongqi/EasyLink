//
//  GroupDetailBottomView.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/7.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupDetailBottomView : UIView

@property (nonatomic, strong) UIButton *guanzhuBtn;
@property (nonatomic, strong) UIButton *quanpinBtn;
@property (nonatomic, strong) UIButton *xiaopinBtn;

// 重写init方法
- (id)initWithFrame:(CGRect)frame andType:(NSInteger) type;

@end
