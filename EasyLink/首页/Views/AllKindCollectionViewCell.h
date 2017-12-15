//
//  AllKindCollectionViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 16/11/17.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllKindCollectionViewCell : UICollectionViewCell

// 图片视图
@property (nonatomic,strong) UIImageView *KindImgView;
// 图片遮罩层
@property (nonatomic,strong) UIImageView *zheZhaoImgView;
// 分类按钮
@property (nonatomic,strong) UIButton *btnKind;
// 简单介绍label
@property (nonatomic,strong) UILabel *titleLb;
// 分类视图
@property (nonatomic,strong) UIView *btnKindUv;

// 创建frame
- (id)initWithFrame:(CGRect)frame;

@end
