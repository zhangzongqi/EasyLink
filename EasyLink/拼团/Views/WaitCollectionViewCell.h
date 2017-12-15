//
//  WaitCollectionViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 17/2/24.
//  Copyright © 2017年 fengdian. All rights reserved.
//  待开团cell

#import <UIKit/UIKit.h>

@interface WaitCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *goodsImgView; // 商品图片
@property (nonatomic, strong) UILabel *titleLb; // 标题label
@property (nonatomic, strong) UILabel *tipWaitLb; // 提示未开团label （不用动）
@property (nonatomic, strong) UILabel *tipDaoJiShiLb; // 倒计时提示文字 （不用动）
@property (nonatomic, strong) UIView *viewForTime; // 倒计时视图
@property (nonatomic, strong) UILabel *waitDayLabel; // 倒计时天数label
@property (nonatomic, strong) UILabel *maohaoLb1;
@property (nonatomic, strong) UILabel *maohaoLb2; // 冒号
@property (nonatomic, strong) UILabel *lbForss; // 秒
@property (nonatomic, strong) UIImageView * rightImgView; // 右侧小图
@property (nonatomic, strong) UILabel *lbFormm; // 分
@property (nonatomic, strong) UILabel *lbForHH; // 时

// 创建frame
- (id)initWithFrame:(CGRect)frame;

@end
