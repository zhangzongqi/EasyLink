//
//  SpellgroupCollectionViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 17/2/8.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpellgroupCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *goodsImgView; // 商品图片
@property (nonatomic, strong) UILabel *titleLb; // 标题label
@property (nonatomic, strong) UIImageView * pinImgView; // 拼团图片
@property (nonatomic, strong) UIImageView * rightImgView; // 右侧小图
@property (nonatomic, strong) UILabel *daojishiLabel; // 倒计时label （显示“活动倒计时,不用动”）
@property (nonatomic, strong) UILabel *countDownLabel; //倒计时label
@property (nonatomic, strong) UILabel *progressBGLabel; // 进度条背景
@property (nonatomic, strong) UIImageView *progressImgView; // 进度条图片
@property (nonatomic, strong) UILabel *currentNumLb; // 当前人数label
@property (nonatomic, strong) UILabel *maxAndPriceLb; // 成团人数
@property (nonatomic, strong) UILabel *priceLb; // 成团价格

@property (nonatomic, strong) UIImageView *smallPersonImageView; // 小人头像（不用动）
@property (nonatomic, strong) UIImageView *smallMorePersonImageView; // 小人头像（不用动）
@property (nonatomic, strong) UILabel *zeroPersonLb; // 0人label（不用动）

// 创建frame
- (id)initWithFrame:(CGRect)frame;

@end
