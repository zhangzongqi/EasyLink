//
//  EvaluateCollectionViewCell.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/1.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h" // 星级

@interface EvaluateCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *touxiangImgView; // 头像
@property (nonatomic, strong) UILabel *nicknameLb; // 昵称
@property (nonatomic, strong) UILabel *dateLb; // 日期
@property (nonatomic, strong) UILabel *pingjiaLb; // 评价
@property (nonatomic, strong) RatingBar *bar; // 星级

// 创建frame
- (id)initWithFrame:(CGRect)frame;

@end
