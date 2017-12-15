//
//  BuyDetailView.h
//  EasyLink
//
//  Created by 琦琦 on 17/3/8.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyDetailView : UIView

@property (nonatomic,strong) UIImageView *goodsImgView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *buyNumLb;
@property (nonatomic,strong) UILabel *onePriceLb;
@property (nonatomic,strong) UILabel *orderGuigeLb; // 规格

@property (nonatomic,strong) UILabel *buyNumViewTipLb; // 提示语
@property (nonatomic,strong) UILabel *buyNumViewNumLb; 
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *subBtn;

@property (nonatomic,strong) UIButton *selectPeisongBtn; // 选择配送btn

@property (nonatomic,strong) UIButton *gouwuquanBtn; // 购物券btn

@property (nonatomic,strong) UILabel *endPriceLb; // 实付价格

- (id)initWithFrame:(CGRect)frame;

@end
