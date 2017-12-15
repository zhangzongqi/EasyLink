//
//  AdressAndNumView.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/1.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdressAndNumView : UIView

@property (nonatomic, copy) UILabel *tipToAddressLb; // 送至
@property (nonatomic, copy) UILabel *tipAlreadySelectLb; // 已选
@property (nonatomic, copy) UIButton *AddressBtn; // 地址Btn
@property (nonatomic, copy) UILabel *lbTipDate; // 提示送达日期
@property (nonatomic, copy) UIButton *selectSizeBtn; // 选取规格按钮

// 创建frame
- (id)initWithFrame:(CGRect)frame;

@end
