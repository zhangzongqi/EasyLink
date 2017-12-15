//
//  SelectPayView.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/8.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "SelectPayView.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation SelectPayView

- (id)initWithFrame:(CGRect)frame {
    
//    640*302
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = FUIColorFromRGB(0xffffff);
        
        
        // 顶部视图
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(Height * 0.2));
        }];
        UILabel *lbtip = [[UILabel alloc] init];
        [topView addSubview:lbtip];
        [lbtip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView);
            make.left.equalTo(topView).with.offset(Width / 32);
            if (iPhone6SP) {
                make.height.equalTo(@(15));
                lbtip.font = [UIFont systemFontOfSize:15];
            }else if (iPhone6S) {
                make.height.equalTo(@(14));
                lbtip.font = [UIFont systemFontOfSize:14];
            }else {
                make.height.equalTo(@(13));
                lbtip.font = [UIFont systemFontOfSize:13];
            }
        }];
        lbtip.textColor = FUIColorFromRGB(0x4e4e4e);
        lbtip.text = @"支付方式";
        // 分割线
        UILabel *lb1 = [[UILabel alloc] init];
        [topView addSubview:lb1];
        [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(topView);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(1));
        }];
        lb1.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        
        
        // 微信
        
        
        _btnWeiXin = [[UIButton alloc] init];
        [self addSubview:_btnWeiXin];
        [_btnWeiXin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(Height * 0.8 / 2));
        }];
        
        // 微信图片
        UIImageView *weixinImgView = [[UIImageView alloc] init];
        [_btnWeiXin addSubview:weixinImgView];
        [weixinImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_btnWeiXin);
            make.left.equalTo(_btnWeiXin).with.offset(Width * 0.034375);
            make.width.equalTo(@(Height * 0.8 / 4));
            make.height.equalTo(@(Height * 0.8 / 4));
        }];
        weixinImgView.image = [UIImage imageNamed:@"order_confirm_weixin"];
        
        _btnWeiXin.imageView.sd_layout
        .rightSpaceToView(_btnWeiXin,Width * 0.0375)
        .centerYEqualToView(_btnWeiXin)
        .heightRatioToView(_btnWeiXin,0.35)
        .widthEqualToHeight();
        if (iPhone6SP) {
            _btnWeiXin.titleLabel.sd_layout
            .leftSpaceToView(weixinImgView,6)
            .centerYEqualToView(_btnWeiXin)
            .heightIs(16);
            _btnWeiXin.titleLabel.font = [UIFont systemFontOfSize:16];
        }else if (iPhone6S) {
            _btnWeiXin.titleLabel.sd_layout
            .leftSpaceToView(weixinImgView,5)
            .centerYEqualToView(_btnWeiXin)
            .heightIs(15);
            _btnWeiXin.titleLabel.font = [UIFont systemFontOfSize:15];
        }else {
            _btnWeiXin.titleLabel.sd_layout
            .leftSpaceToView(weixinImgView,4)
            .centerYEqualToView(_btnWeiXin)
            .heightIs(14);
            _btnWeiXin.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        [_btnWeiXin setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
        [_btnWeiXin setTitle:@"微信支付" forState:UIControlStateNormal];
        [_btnWeiXin setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_btnWeiXin setImage:[UIImage imageNamed:@"order_confirm_select"] forState:UIControlStateSelected];
        _btnWeiXin.selected = NO;
        // 分割线
        UILabel *lb2 = [[UILabel alloc] init];
        [_btnWeiXin addSubview:lb2];
        [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_btnWeiXin);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(1));
        }];
        lb2.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        
        // 支付宝
        _btnAliPay = [[UIButton alloc] init];
        [self addSubview:_btnAliPay];
        [_btnAliPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_btnWeiXin.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(Height * 0.8 / 2));
        }];
        // 支付宝图片
        UIImageView *aliPayImgView = [[UIImageView alloc] init];
        [_btnAliPay addSubview:aliPayImgView];
        [aliPayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_btnAliPay);
            make.left.equalTo(_btnAliPay).with.offset(Width * 0.034375);
            make.width.equalTo(@(Height * 0.8 / 4));
            make.height.equalTo(@(Height * 0.8 / 4));
        }];
        aliPayImgView.image = [UIImage imageNamed:@"order_confirm_zhifubao"];
        _btnAliPay.imageView.sd_layout
        .rightSpaceToView(_btnAliPay,Width * 0.0375)
        .centerYEqualToView(_btnAliPay)
        .heightRatioToView(_btnAliPay,0.35)
        .widthEqualToHeight();
        if (iPhone6SP) {
            _btnAliPay.titleLabel.sd_layout
            .leftSpaceToView(aliPayImgView,6)
            .centerYEqualToView(_btnAliPay)
            .heightIs(16);
            _btnAliPay.titleLabel.font = [UIFont systemFontOfSize:16];
        }else if (iPhone6S) {
            _btnAliPay.titleLabel.sd_layout
            .leftSpaceToView(aliPayImgView,5)
            .centerYEqualToView(_btnAliPay)
            .heightIs(15);
            _btnAliPay.titleLabel.font = [UIFont systemFontOfSize:15];
        }else {
            _btnAliPay.titleLabel.sd_layout
            .leftSpaceToView(aliPayImgView,4)
            .centerYEqualToView(_btnAliPay)
            .heightIs(14);
            _btnAliPay.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        [_btnAliPay setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
        [_btnAliPay setTitle:@"支付宝支付" forState:UIControlStateNormal];
        [_btnAliPay setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_btnAliPay setImage:[UIImage imageNamed:@"order_confirm_select"] forState:UIControlStateSelected];
        _btnAliPay.selected = NO;
        
        // 分割线
        UILabel *lb3 = [[UILabel alloc] init];
        [_btnAliPay addSubview:lb3];
        [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_btnAliPay);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(1));
        }];
        lb3.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        // QQ
//        _btnQQ = [[UIButton alloc] init];
//        [self addSubview:_btnQQ];
//        [_btnQQ mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_btnAliPay.mas_bottom);
//            make.left.equalTo(self);
//            make.width.equalTo(@(Width));
//            make.height.equalTo(@(Height * 0.8 / 3));
//        }];
//        // QQ图片
//        UIImageView *QQImgView = [[UIImageView alloc] init];
//        [_btnQQ addSubview:QQImgView];
//        [QQImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_btnQQ);
//            make.left.equalTo(_btnQQ).with.offset(Width * 0.034375);
//            make.width.equalTo(@(Height * 0.8 / 6));
//            make.height.equalTo(@(Height * 0.8 / 6));
//        }];
//        QQImgView.image = [UIImage imageNamed:@"order_confirm_qq"];
//        _btnQQ.imageView.sd_layout
//        .rightSpaceToView(_btnQQ,Width * 0.0375)
//        .centerYEqualToView(_btnQQ)
//        .heightRatioToView(_btnQQ,0.35)
//        .widthEqualToHeight();
//        if (iPhone6SP) {
//            _btnQQ.titleLabel.sd_layout
//            .leftSpaceToView(QQImgView,6)
//            .centerYEqualToView(_btnQQ)
//            .heightIs(16);
//            _btnQQ.titleLabel.font = [UIFont systemFontOfSize:16];
//        }else if (iPhone6S) {
//            _btnQQ.titleLabel.sd_layout
//            .leftSpaceToView(QQImgView,5)
//            .centerYEqualToView(_btnQQ)
//            .heightIs(15);
//            _btnQQ.titleLabel.font = [UIFont systemFontOfSize:15];
//        }else {
//            _btnQQ.titleLabel.sd_layout
//            .leftSpaceToView(QQImgView,4)
//            .centerYEqualToView(_btnQQ)
//            .heightIs(14);
//            _btnQQ.titleLabel.font = [UIFont systemFontOfSize:14];
//        }
//        [_btnQQ setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
//        [_btnQQ setTitle:@"QQ钱包支付" forState:UIControlStateNormal];
//        [_btnQQ setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [_btnQQ setImage:[UIImage imageNamed:@"order_confirm_select"] forState:UIControlStateSelected];
//        _btnQQ.selected = NO;
        // 分割线
//        UILabel *lb4 = [[UILabel alloc] init];
//        [_btnQQ addSubview:lb4];
//        [lb4 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_btnQQ);
//            make.left.equalTo(self);
//            make.width.equalTo(@(Width));
//            make.height.equalTo(@(1));
//        }];
//        lb4.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
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
