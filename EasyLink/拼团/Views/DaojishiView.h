//
//  DaojishiView.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/10.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaojishiView : UIView

@property (nonatomic, strong) UILabel *yipinLb; // 已拼Lb
@property (nonatomic, strong) UILabel *miaoLb1;
@property (nonatomic, strong) UILabel *miaoLb2;
@property (nonatomic, strong) UILabel *fenLb1;
@property (nonatomic, strong) UILabel *fenLb2;
@property (nonatomic, strong) UILabel *shiLb1;
@property (nonatomic, strong) UILabel *shiLb2;

@property (nonatomic, strong) UILabel *shiOrDayTip;
@property (nonatomic, strong) UILabel *fenOrShiTip;
@property (nonatomic, strong) UILabel *miaoOrFenTip;


/// 定时器，使用 weak 或者 strong 都行
@property (nonatomic, strong) NSTimer *timer;
/// 剩余天数
@property (nonatomic, assign) NSUInteger day;
/// 剩余小时数
@property (nonatomic, assign) NSUInteger hour;
/// 剩余分钟数
@property (nonatomic, assign) NSUInteger minute;
/// 剩余秒数
@property (nonatomic, assign) NSUInteger second;


- (id)initWithFrame:(CGRect)frame;

// 从外部传入时间戳，开始倒计时
- (void) giveEndTime:(NSString *)timeStr;

@end
