//
//  WaitPayOrderCollectionViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/6.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitPayOrderCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *orderNumLb; // 订单编号
@property (nonatomic, strong) UILabel *statusLb; // 订单状态
@property (nonatomic, strong) UIImageView *imgView; // 订单图片
@property (nonatomic, strong) UILabel *titleLb; // 标题label
@property (nonatomic, strong) UILabel *orderGuigeLb; // 订单规格
@property (nonatomic, strong) UILabel *buyNumLb; // 购买数量
@property (nonatomic, strong) UILabel *priceLb; // 订单金额
@property (nonatomic, strong) UIButton *btnForCancleLogistics; // 取消，查看物流按钮
@property (nonatomic, strong) UIButton *btnForPayConfirmDelete; // 确认收货、支付、删除按钮

// 创建frame
- (id)initWithFrame:(CGRect)frame;

@end
