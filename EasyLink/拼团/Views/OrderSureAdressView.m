//
//  OrderSureAdressView.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/8.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "OrderSureAdressView.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation OrderSureAdressView

// 创建frame
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = FUIColorFromRGB(0xffffff);
        
        // 地址小图标
        UIImageView *imgView = [[UIImageView alloc] init];
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(Width * 3/64);
            make.width.equalTo(@(15));
            make.height.equalTo(@(18));
        }];
        imgView.image = [UIImage imageNamed:@"order_location"];
        
        // 右侧小按钮
        UIButton *rightBtn = [[UIButton alloc] init];
        [self addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(- Width * 0.03125);
            make.width.equalTo(@(7.42857));
            make.height.equalTo(@(13));
        }];
        [rightBtn setImage:[UIImage imageNamed:@"account_forward"] forState:UIControlStateNormal];
        
        // 地址按钮
        _adressBtn =[[UIButton alloc] init];
        [self addSubview:_adressBtn];
        [_adressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(imgView.mas_right).with.offset(Width * 0.028125);
            make.right.equalTo(rightBtn.mas_left).with.offset(- Width * 0.03125);
            make.height.equalTo(self);
        }];
        [_adressBtn setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
        _adressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _adressBtn.titleLabel.sd_layout
        .leftSpaceToView(_adressBtn,0)
        .centerYEqualToView(_adressBtn)
        .heightRatioToView(_adressBtn,1);
        _adressBtn.titleLabel.numberOfLines = 0;
        
        // 底部图片
        UIImageView *bottomImgView = [[UIImageView alloc] init];
        [self addSubview:bottomImgView];
        [bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(1));
        }];
        UIImage *image2 = [UIImage imageNamed:@"order_location_line"];
        CGFloat top = 0; // 顶端盖高度
        CGFloat bottom = 0 ; // 底端盖高度
        CGFloat left = 0; // 左端盖宽度
        CGFloat right = 0; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        image2 = [image2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
        //    UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
        //    UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片
        bottomImgView.image = image2;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
