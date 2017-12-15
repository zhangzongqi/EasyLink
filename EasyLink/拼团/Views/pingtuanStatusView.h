//
//  pingtuanStatusView.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/10.
//  Copyright © 2017年 fengdian. All rights reserved.
//  拼团状态

#import <UIKit/UIKit.h>

@interface pingtuanStatusView : UIView

@property (nonatomic,strong) UILabel *statusLb; // 状态
@property (nonatomic,strong) UILabel *songDaTimeLb;// 送达时间

- (id)initWithFrame:(CGRect)frame;

@end
