//
//  AdressAndNumView.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/1.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "AdressAndNumView.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation AdressAndNumView

// 创建frame
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 172 * 640
        
        // 送至
        _tipToAddressLb = [[UILabel alloc] init];
        [self addSubview:_tipToAddressLb];
        [_tipToAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(HEIGHT * 0.16);
            make.left.equalTo(self).with.offset(WIDTH * 0.03125);
            if (iPhone6SP) {
                make.height.equalTo(@(14));
                _tipToAddressLb.font = [UIFont systemFontOfSize:14];
            }else if (iPhone6S) {
                make.height.equalTo(@(13));
                _tipToAddressLb.font = [UIFont systemFontOfSize:13];
            }else {
                make.height.equalTo(@(12));
                _tipToAddressLb.font = [UIFont systemFontOfSize:12];
            }
        }];
        _tipToAddressLb.textColor = FUIColorFromRGB(0x999999);
        _tipToAddressLb.text = @"送至";
            
        // 已选
        _tipAlreadySelectLb = [[UILabel alloc] init];
        [self addSubview:_tipAlreadySelectLb];
        [_tipAlreadySelectLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(- HEIGHT * 0.12);
            make.left.equalTo(_tipToAddressLb);
            if (iPhone6SP) {
                make.height.equalTo(@(14));
                _tipAlreadySelectLb.font = [UIFont systemFontOfSize:14];
            }else if (iPhone6S) {
                make.height.equalTo(@(13));
                _tipAlreadySelectLb.font = [UIFont systemFontOfSize:13];
            }else {
                make.height.equalTo(@(12));
                _tipAlreadySelectLb.font = [UIFont systemFontOfSize:12];
            }
        }];
        _tipAlreadySelectLb.textColor = FUIColorFromRGB(0x999999);
        _tipAlreadySelectLb.text = @"已选";
        
        // 地址Btn
        _AddressBtn = [[UIButton alloc] init];
        [self addSubview:_AddressBtn];
        [_AddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tipToAddressLb);
            make.left.equalTo(_tipToAddressLb.mas_right).with.offset(WIDTH * 0.03125);
            make.width.equalTo(@(WIDTH - WIDTH*0.03125*4 - _tipToAddressLb.width - 7.5));
            make.height.equalTo(@(HEIGHT * 0.36));
        }];
        
        // 右侧大于号图片
        UIImageView *rightImgView = [[UIImageView alloc] init];
        [self addSubview:rightImgView];
        [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(- WIDTH * 0.03125);
            make.centerY.equalTo(_AddressBtn);
            make.width.equalTo(@(7.42857));
            make.height.equalTo(@(13));
        }];
        rightImgView.image = [UIImage imageNamed:@"account_forward"];
        
        // 图片大小
        if (iPhone6SP) {
            _AddressBtn.imageView.sd_layout
            .leftEqualToView(_AddressBtn)
            .centerYEqualToView(_AddressBtn)
            .widthIs(13)
            .heightIs(15.6);
            _AddressBtn.titleLabel.sd_layout
            .leftSpaceToView(_AddressBtn.imageView,4)
            .centerYEqualToView(_AddressBtn)
            .heightIs(14);
            _AddressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }else if (iPhone6S) {
            _AddressBtn.imageView.sd_layout
            .leftEqualToView(_AddressBtn)
            .centerYEqualToView(_AddressBtn)
            .widthIs(12)
            .heightIs(14.4);
            _AddressBtn.titleLabel.sd_layout
            .leftSpaceToView(_AddressBtn.imageView,3)
            .centerYEqualToView(_AddressBtn)
            .heightIs(13);
            _AddressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        }else {
            _AddressBtn.imageView.sd_layout
            .leftEqualToView(_AddressBtn)
            .centerYEqualToView(_AddressBtn)
            .widthIs(11)
            .heightIs(13.2);
            _AddressBtn.titleLabel.sd_layout
            .leftSpaceToView(_AddressBtn.imageView,2)
            .centerYEqualToView(_AddressBtn)
            .heightIs(12);
            _AddressBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        }
        // 图片
        [_AddressBtn setImage:[UIImage imageNamed:@"order_location"] forState:UIControlStateNormal];
        [_AddressBtn setTitleColor:FUIColorFromRGB(0x212121) forState:UIControlStateNormal];
        
        // 提示送达日期
        _lbTipDate = [[UILabel alloc] init];
        [self addSubview:_lbTipDate];
        [_lbTipDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_AddressBtn.mas_bottom);
            make.left.equalTo(_AddressBtn);
            if (iPhone6SP) {
                make.height.equalTo(@(13));
                _lbTipDate.font = [UIFont systemFontOfSize:13];
            }else if (iPhone6S) {
                make.height.equalTo(@(12));
                _lbTipDate.font = [UIFont systemFontOfSize:12];
            }else {
                make.height.equalTo(@(11));
                _lbTipDate.font = [UIFont systemFontOfSize:11];
            }
        }];
        _lbTipDate.textColor = FUIColorFromRGB(0x999999);
        
        
        // 分割线
        UILabel *lbFenge = [[UILabel alloc] init];
        [self addSubview:lbFenge];
        [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_tipAlreadySelectLb.mas_top).with.offset(- HEIGHT * 0.12);
            make.left.equalTo(_tipToAddressLb);
            make.width.equalTo(@(WIDTH - WIDTH*0.03125));
            make.height.equalTo(@(1));
        }];
        lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        // 选取规格按钮
        _selectSizeBtn = [[UIButton alloc] init];
        [self addSubview:_selectSizeBtn];
        [_selectSizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tipAlreadySelectLb);
            make.left.equalTo(_tipAlreadySelectLb.mas_right).with.offset(WIDTH*0.03125);
            make.height.equalTo(@(_tipAlreadySelectLb.height +  0.24 * HEIGHT));
            make.width.equalTo(@(WIDTH - WIDTH*0.03125*4 - _tipToAddressLb.width - 7.5));
        }];
        
        // 按钮文字
        _selectSizeBtn.titleLabel.sd_layout
        .centerYEqualToView(_selectSizeBtn)
        .leftEqualToView(_selectSizeBtn)
        .rightEqualToView(_selectSizeBtn);
        if (iPhone6SP) {
            _selectSizeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }else if (iPhone6S) {
            _selectSizeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        }else {
            _selectSizeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        }
        [_selectSizeBtn setTitleColor:FUIColorFromRGB(0x212121) forState:UIControlStateNormal];
        // 右侧大于号图标
        UIImageView *rightImgView2 = [[UIImageView alloc] init];
        [self addSubview:rightImgView2];
        [rightImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightImgView);
            make.centerY.equalTo(_selectSizeBtn);
            make.width.equalTo(@(7.42857));
            make.height.equalTo(@(13));
        }];
        rightImgView2.image = [UIImage imageNamed:@"account_forward"];
        
        // 分割线
        UILabel *lbFenge2 = [[UILabel alloc] init];
        [self addSubview:lbFenge2];
        [lbFenge2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(_tipToAddressLb);
            make.width.equalTo(@(WIDTH - WIDTH*0.03125));
            make.height.equalTo(@(1));
        }];
        lbFenge2.backgroundColor = FUIColorFromRGB(0xeeeeee);
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
