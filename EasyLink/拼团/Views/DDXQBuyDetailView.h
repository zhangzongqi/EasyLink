//
//  DDXQBuyDetailView.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/9.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDXQBuyDetailView : UIView

@property (nonatomic,strong) UIImageView *goodsImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *buyNumLb;
@property (nonatomic,strong) UILabel *onePriceLb;
@property (nonatomic,strong) UILabel *orderGuigeLb; // 规格

@property (nonatomic,strong) UILabel *peiSongLabel; // 选择配送label

@property (nonatomic,strong) UILabel *gouwuquanLabel; // 购物券label

@property (nonatomic,strong) UILabel *endPriceLb; // 实付价格

- (id)initWithFrame:(CGRect)frame;

@end
