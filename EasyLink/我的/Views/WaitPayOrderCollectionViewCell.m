//
//  WaitPayOrderCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/6.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "WaitPayOrderCollectionViewCell.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation WaitPayOrderCollectionViewCell

- (id) initWithFrame:(CGRect)frame {
    
//    640*300
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 订单号，订单状态视图
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(Height * 29/150));
            
        }];
        topView.backgroundColor = FUIColorFromRGB(0xffffff);
        
        // 分割线
        UILabel *lbFenge = [[UILabel alloc] init];
        [topView addSubview:lbFenge];
        [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView);
            make.bottom.equalTo(topView);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(1));
        }];
        lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        // 订单号
        _orderNumLb = [[UILabel alloc] init];
        [topView addSubview:_orderNumLb];
        [_orderNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(0.03125 * Width);
            make.centerY.equalTo(topView);
            if (iPhone6SP) {
                make.height.equalTo(@(14));
                _orderNumLb.font = [UIFont systemFontOfSize:14];
            }else if (iPhone6S) {
                make.height.equalTo(@(13));
                _orderNumLb.font = [UIFont systemFontOfSize:13];
            }else {
                make.height.equalTo(@(12));
                _orderNumLb.font = [UIFont systemFontOfSize:12];
            }
        }];
        _orderNumLb.textColor = FUIColorFromRGB(0x4e4e4e);
        
        // 待付款
        _statusLb = [[UILabel alloc] init];
        [topView addSubview:_statusLb];
        [_statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView);
            make.right.equalTo(self).with.offset(- 0.03125 * Width);
            if (iPhone6SP) {
                make.height.equalTo(@(14));
                _statusLb.font = [UIFont systemFontOfSize:14];
            }else if (iPhone6S) {
                make.height.equalTo(@(13));
                _statusLb.font = [UIFont systemFontOfSize:13];
            }else {
                make.height.equalTo(@(12));
                _statusLb.font = [UIFont systemFontOfSize:12];
            }
        }];
        _statusLb.textColor = FUIColorFromRGB(0x8979ff);
        
        
        // 中间视图
        UIView *centerView = [[UIView alloc] init];
        [self addSubview:centerView];
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(Height * 0.57));
        }];
        centerView.backgroundColor = FUIColorFromRGB(0xffffff);
        
        // 商品图片
        _imgView = [[UIImageView alloc] init];
        [centerView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerView).with.offset(0.03125 * Width);
            make.centerY.equalTo(centerView);
            make.height.equalTo(@(Height * 0.57 * 12 / 17));
            make.width.equalTo(@(Height * 0.57 * 12 / 17));
        }];
        _imgView.backgroundColor = [UIColor redColor];
        _imgView.layer.cornerRadius = Height * 0.57 * 12 / 17 / 2;
        _imgView.clipsToBounds = YES;
        _imgView.layer.borderColor = FUIColorFromRGB(0xeeeeee).CGColor;
        _imgView.layer.borderWidth = 1.0;
        
        // 分割线
        UILabel *lbFenge2 = [[UILabel alloc] init];
        [centerView addSubview:lbFenge2];
        [lbFenge2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(centerView);
            make.left.equalTo(_imgView).with.offset(Height * 0.57 * 12 / 17 / 2);
            make.right.equalTo(centerView);
            make.height.equalTo(@(1));
        }];
        lbFenge2.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        // titlelb
        _titleLb = [[UILabel alloc] init];
        [centerView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerView).with.offset(Height * 0.57 * 7/34);
            make.left.equalTo(_imgView.mas_right).with.offset(0.03125 * Width);
            make.right.equalTo(centerView).with.offset(- 0.03125 * Width);
            if (iPhone6SP) {
                make.height.equalTo(@(15));
                _titleLb.font = [UIFont systemFontOfSize:15];
            }else if (iPhone6S) {
                make.height.equalTo(@(14));
                _titleLb.font = [UIFont systemFontOfSize:14];
            }else {
                make.height.equalTo(@(13));
                _titleLb.font = [UIFont systemFontOfSize:13];
            }
        }];
        _titleLb.textColor = FUIColorFromRGB(0x212121);
        
        
        // 价格
        _priceLb = [[UILabel alloc] init];
        [centerView addSubview:_priceLb];
        [_priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(centerView).with.offset(- Height * 0.57 * 7/34);
            make.right.equalTo(centerView).with.offset(- 0.03125 * Width);
            if (iPhone6SP) {
                make.height.equalTo(@(15));
                _priceLb.font = [UIFont systemFontOfSize:15];
            }else if (iPhone6S) {
                make.height.equalTo(@(14));
                _priceLb.font = [UIFont systemFontOfSize:14];
            }else {
                make.height.equalTo(@(13));
                _priceLb.font = [UIFont systemFontOfSize:13];
            }
        }];
        _priceLb.textColor = FUIColorFromRGB(0xff5571);
        
        // 购买数量
        _buyNumLb = [[UILabel alloc] init];
        [centerView addSubview:_buyNumLb];
        [_buyNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_priceLb);
            make.left.equalTo(_titleLb);
            if (iPhone6SP) {
                make.height.equalTo(@(14));
                _buyNumLb.font = [UIFont systemFontOfSize:14];
            }else if (iPhone6S) {
                make.height.equalTo(@(13));
                _buyNumLb.font = [UIFont systemFontOfSize:13];
            }else {
                make.height.equalTo(@(12));
                _buyNumLb.font = [UIFont systemFontOfSize:12];
            }
        }];
        _buyNumLb.textColor = FUIColorFromRGB(0x999999);
        
        // 规格label
        _orderGuigeLb = [[UILabel alloc] init];
        [centerView addSubview:_orderGuigeLb];
        [_orderGuigeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLb.mas_bottom).with.offset(Height * 0.57 * 3/34);
            make.left.equalTo(_titleLb);
            make.right.equalTo(_titleLb);
            if (iPhone6SP) {
                make.height.equalTo(@(14));
                _orderGuigeLb.font = [UIFont systemFontOfSize:14];
            }else if (iPhone6S) {
                make.height.equalTo(@(13));
                _orderGuigeLb.font = [UIFont systemFontOfSize:13];
            }else {
                make.height.equalTo(@(12));
                _orderGuigeLb.font = [UIFont systemFontOfSize:12];
            }
        }];
        _orderGuigeLb.textColor = FUIColorFromRGB(0x999999);
        
        
        // 底部视图
        UIView *bottomView = [[UIView alloc] init];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(Height * 35.5 / 150));
        }];
        bottomView.backgroundColor = FUIColorFromRGB(0xffffff);
        
        // 确认收货、立即支付、删除按钮
        _btnForPayConfirmDelete = [[UIButton alloc] init];
        [bottomView addSubview:_btnForPayConfirmDelete];
        [_btnForPayConfirmDelete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView);
            make.right.equalTo(bottomView).with.offset(- 0.03125 * Width);
            make.height.equalTo(@(Height * 35.5 / 150 * 4/7));
            make.width.equalTo(@(Width * 0.196875));
        }];
        if (iPhone6SP) {
            _btnForPayConfirmDelete.titleLabel.font = [UIFont systemFontOfSize:14];
        }else if (iPhone6S) {
            _btnForPayConfirmDelete.titleLabel.font = [UIFont systemFontOfSize:13];
        }else {
            _btnForPayConfirmDelete.titleLabel.font = [UIFont systemFontOfSize:12];
        }
        [_btnForPayConfirmDelete setTitleColor:FUIColorFromRGB(0x8979ff) forState:UIControlStateNormal];
        _btnForPayConfirmDelete.layer.cornerRadius = Height * 35.5 / 150 * 4/14;
        _btnForPayConfirmDelete.clipsToBounds = YES;
        _btnForPayConfirmDelete.layer.borderWidth = 1.0;
        _btnForPayConfirmDelete.layer.borderColor = FUIColorFromRGB(0xbcb2ff).CGColor;
        
        
        // 取消，查看物流按钮
        _btnForCancleLogistics = [[UIButton alloc] init];
        [bottomView addSubview:_btnForCancleLogistics];
        [_btnForCancleLogistics mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView);
            make.right.equalTo(_btnForPayConfirmDelete.mas_left).with.offset(- 0.03125 * Width);
            make.height.equalTo(@(Height * 35.5 / 150 * 4/7));
            make.width.equalTo(@(Width * 0.196875));
        }];
        if (iPhone6SP) {
            _btnForCancleLogistics.titleLabel.font = [UIFont systemFontOfSize:14];
        }else if (iPhone6S) {
            _btnForCancleLogistics.titleLabel.font = [UIFont systemFontOfSize:13];
        }else {
            _btnForCancleLogistics.titleLabel.font = [UIFont systemFontOfSize:12];
        }
        [_btnForCancleLogistics setTitleColor:FUIColorFromRGB(0x4e4e4e) forState:UIControlStateNormal];
        _btnForCancleLogistics.layer.cornerRadius = Height * 35.5 / 150 * 4/14;
        _btnForCancleLogistics.clipsToBounds = YES;
        _btnForCancleLogistics.layer.borderWidth = 1.0;
        _btnForCancleLogistics.layer.borderColor = FUIColorFromRGB(0xe4e4e4).CGColor;
        
    }
    
    return self;
}

@end
