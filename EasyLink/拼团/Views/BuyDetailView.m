//
//  BuyDetailView.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/8.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "BuyDetailView.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation BuyDetailView

- (id) initWithFrame:(CGRect)frame {
//    640*492
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = FUIColorFromRGB(0xffffff);
        
        CGFloat topViewHeight = Height * 0.34756097560976;
        
        // 640*171
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(topViewHeight));
        }];
        // 分割线
        UILabel *lbFenge = [[UILabel alloc] init];
        [topView addSubview:lbFenge];
        [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView).with.offset(Width * 0.03125);
            make.bottom.equalTo(topView);
            make.right.equalTo(topView);
            make.height.equalTo(@(1));
        }];
        lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        // 商品图片
        _goodsImgView =[[UIImageView alloc] init];
        [topView addSubview:_goodsImgView];
        [_goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView);
            make.left.equalTo(lbFenge);
            make.width.equalTo(@(topViewHeight * 12/17));
            make.height.equalTo(@(topViewHeight * 12/17));
        }];
        _goodsImgView.layer.cornerRadius = topViewHeight * 12/34;
        _goodsImgView.layer.borderColor = [FUIColorFromRGB(0xeeeeee) CGColor];
        _goodsImgView.layer.borderWidth = 1.0;
        _goodsImgView.clipsToBounds = YES;
        
        // titlelb
        _titleLb = [[UILabel alloc] init];
        [topView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).with.offset(topViewHeight * 0.2);
            make.left.equalTo(_goodsImgView.mas_right).with.offset(0.0234375 * Width);
            make.right.equalTo(topView).with.offset(- 0.03125 * Width);
            if (iPhone6SP) {
                make.height.equalTo(@(16));
                _titleLb.font = [UIFont systemFontOfSize:16];
            }else if (iPhone6S) {
                make.height.equalTo(@(15));
                _titleLb.font = [UIFont systemFontOfSize:15];
            }else {
                make.height.equalTo(@(14));
                _titleLb.font = [UIFont systemFontOfSize:14];
            }
        }];
        _titleLb.textColor = FUIColorFromRGB(0x212121);
        
        
        // 购买数量
        _buyNumLb = [[UILabel alloc] init];
        [topView addSubview:_buyNumLb];
        [_buyNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(topView).with.offset(- topViewHeight * 0.18);
            make.right.equalTo(topView).with.offset(- 0.03125 * Width);
            if (iPhone6SP) {
                make.height.equalTo(@(15));
                _buyNumLb.font = [UIFont systemFontOfSize:15];
            }else if (iPhone6S) {
                make.height.equalTo(@(14));
                _buyNumLb.font = [UIFont systemFontOfSize:14];
            }else {
                make.height.equalTo(@(13));
                _buyNumLb.font = [UIFont systemFontOfSize:13];
            }
        }];
        _buyNumLb.textColor = FUIColorFromRGB(0x999999);
        
        // 单价
        _onePriceLb = [[UILabel alloc] init];
        [topView addSubview:_onePriceLb];
        [_onePriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_buyNumLb);
            make.left.equalTo(_titleLb);
            if (iPhone6SP) {
                make.height.equalTo(@(16));
                _onePriceLb.font = [UIFont systemFontOfSize:16];
            }else if (iPhone6S) {
                make.height.equalTo(@(15));
                _onePriceLb.font = [UIFont systemFontOfSize:15];
            }else {
                make.height.equalTo(@(14));
                _onePriceLb.font = [UIFont systemFontOfSize:14];
            }
        }];
        _onePriceLb.textColor = FUIColorFromRGB(0xff5571);
        
        // 规格label
        _orderGuigeLb = [[UILabel alloc] init];
        [topView addSubview:_orderGuigeLb];
        [_orderGuigeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLb.mas_bottom).with.offset(topViewHeight * 0.07);
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
        
        
        
        CGFloat BuyNumViewHeight = Height * 0.16463414634146;
        
        // BuyNumView
//        640*81
        UIView *BuyNumView = [[UIView alloc] init];
        [self addSubview:BuyNumView];
        [BuyNumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(BuyNumViewHeight));
        }];
        // 分割线
        UILabel *lbFenge2 = [[UILabel alloc] init];
        [BuyNumView addSubview:lbFenge2];
        [lbFenge2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(BuyNumView);
            make.left.equalTo(lbFenge);
            make.width.equalTo(lbFenge);
            make.height.equalTo(@(1));
        }];
        lbFenge2.backgroundColor = FUIColorFromRGB(0xeeeeee);
        // 购买数量提示lb
        UILabel *buyNumTipLb = [[UILabel alloc] init];
        [BuyNumView addSubview:buyNumTipLb];
        [buyNumTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(BuyNumView);
            make.left.equalTo(lbFenge2);
            if (iPhone6SP) {
                make.height.equalTo(@(16));
                buyNumTipLb.font = [UIFont systemFontOfSize:16];
            }else if (iPhone6S) {
                make.height.equalTo(@(15));
                buyNumTipLb.font = [UIFont systemFontOfSize:15];
            }else {
                make.height.equalTo(@(14));
                buyNumTipLb.font = [UIFont systemFontOfSize:14];
            }
        }];
        buyNumTipLb.textColor = FUIColorFromRGB(0x4e4e4e);
        buyNumTipLb.text = @"购买数量";
        
        // 加按钮
        _addBtn = [[UIButton alloc] init];
        [self addSubview:_addBtn];
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(BuyNumView).with.offset(- Width * 0.03125);
            make.centerY.equalTo(BuyNumView);
            make.height.equalTo(@(BuyNumViewHeight * 0.5));
            make.width.equalTo(@(BuyNumViewHeight * 0.5));
        }];
        _addBtn.backgroundColor = FUIColorFromRGB(0xeeeeee);
        [_addBtn setTitle:@"＋" forState:UIControlStateNormal];
        [_addBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _addBtn.layer.cornerRadius = BuyNumViewHeight * 0.5/2;
        _addBtn.clipsToBounds = YES;
        
        // 购买数量
        _buyNumViewNumLb = [[UILabel alloc] init];
        [self addSubview:_buyNumViewNumLb];
        [_buyNumViewNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(BuyNumView);
            make.right.equalTo(_addBtn.mas_left);
            make.width.equalTo(@(Width * 0.16875));
            make.height.equalTo(@(BuyNumViewHeight));
        }];
        _buyNumViewNumLb.textColor = FUIColorFromRGB(0x212121);
        _buyNumViewNumLb.textAlignment = NSTextAlignmentCenter;
        _buyNumViewNumLb.font = [UIFont systemFontOfSize:14];
        
        // 减按钮
        _subBtn = [[UIButton alloc] init];
        [self addSubview:_subBtn];
        [_subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_buyNumViewNumLb.mas_left);
            make.centerY.equalTo(BuyNumView);
            make.height.equalTo(@(BuyNumViewHeight * 0.5));
            make.width.equalTo(@(BuyNumViewHeight * 0.5));
        }];
        _subBtn.backgroundColor = FUIColorFromRGB(0xeeeeee);
        [_subBtn setTitle:@"－" forState:UIControlStateNormal];
        [_subBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _subBtn.layer.cornerRadius = BuyNumViewHeight * 0.5/2;
        _subBtn.clipsToBounds = YES;
        
        // 提示语
        _buyNumViewTipLb = [[UILabel alloc] init];
        [BuyNumView addSubview: _buyNumViewTipLb];
        [_buyNumViewTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(BuyNumView);
            make.left.equalTo(buyNumTipLb.mas_right).with.offset(Width * 0.01875);
            if (iPhone6SP) {
                make.height.equalTo(@(15));
                _buyNumViewTipLb.font = [UIFont systemFontOfSize:15];
            }else if (iPhone6S) {
                make.height.equalTo(@(14));
                _buyNumViewTipLb.font = [UIFont systemFontOfSize:14];
            }else {
                make.height.equalTo(@(13));
                _buyNumViewTipLb.font = [UIFont systemFontOfSize:13];
            }
        }];
        _buyNumViewTipLb.textColor = FUIColorFromRGB(0x999999);
        
        
        // 配送View
        UIView *peisongView = [[UIView alloc] init];
        [self addSubview: peisongView];
        [peisongView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(BuyNumView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(BuyNumView);
        }];
        // 分割线
        UILabel *lbFenge3 = [[UILabel alloc] init];
        [peisongView addSubview:lbFenge3];
        [lbFenge3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(peisongView);
            make.left.equalTo(lbFenge);
            make.width.equalTo(lbFenge);
            make.height.equalTo(@(1));
        }];
        lbFenge3.backgroundColor = FUIColorFromRGB(0xeeeeee);
        // 配送信息提示lb
        UILabel *peisongTipLb = [[UILabel alloc] init];
        [BuyNumView addSubview:peisongTipLb];
        [peisongTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(peisongView);
            make.left.equalTo(lbFenge3);
            if (iPhone6SP) {
                make.height.equalTo(@(16));
                peisongTipLb.font = [UIFont systemFontOfSize:16];
            }else if (iPhone6S) {
                make.height.equalTo(@(15));
                peisongTipLb.font = [UIFont systemFontOfSize:15];
            }else {
                make.height.equalTo(@(14));
                peisongTipLb.font = [UIFont systemFontOfSize:14];
            }
        }];
        peisongTipLb.textColor = FUIColorFromRGB(0x4e4e4e);
        peisongTipLb.text = @"配送信息";
        
        // 选择快递按钮
        _selectPeisongBtn = [[UIButton alloc] init];
        [self addSubview:_selectPeisongBtn];
        [_selectPeisongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(peisongView);
            make.right.equalTo(self).with.offset(- Width * 0.03125);
            make.height.equalTo(peisongView);
        }];
        _selectPeisongBtn.imageView.sd_layout
        .centerYEqualToView(_selectPeisongBtn)
        .rightEqualToView(_selectPeisongBtn)
        .widthIs(7.42857)
        .heightIs(13);
        if (iPhone6SP) {
            _selectPeisongBtn.titleLabel.sd_layout
            .rightSpaceToView(_selectPeisongBtn.imageView,6)
            .centerYEqualToView(_selectPeisongBtn)
            .heightIs(15)
            .widthIs(200);
            _selectPeisongBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        }else if (iPhone6S) {
            _selectPeisongBtn.titleLabel.sd_layout
            .rightSpaceToView(_selectPeisongBtn.imageView,5)
            .centerYEqualToView(_selectPeisongBtn)
            .heightIs(14)
            .widthIs(200);
            _selectPeisongBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }else {
            _selectPeisongBtn.titleLabel.sd_layout
            .rightSpaceToView(_selectPeisongBtn.imageView,4)
            .centerYEqualToView(_selectPeisongBtn)
            .heightIs(13)
            .widthIs(200);
            _selectPeisongBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        [_selectPeisongBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_selectPeisongBtn setImage:[UIImage imageNamed:@"account_forward"] forState:UIControlStateNormal];
        _selectPeisongBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        
        
        
        // 购物券view
        UIView *gouwuquanView = [[UIView alloc] init];
        [self addSubview:gouwuquanView];
        [gouwuquanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(peisongView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(BuyNumViewHeight));
        }];
        // 分割线
        UILabel *lbFenge4 = [[UILabel alloc] init];
        [gouwuquanView addSubview:lbFenge4];
        [lbFenge4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(gouwuquanView);
            make.left.equalTo(lbFenge);
            make.width.equalTo(lbFenge);
            make.height.equalTo(@(1));
        }];
        lbFenge4.backgroundColor = FUIColorFromRGB(0xeeeeee);
        // 配送信息提示lb
        UILabel *gouwuquanTipLb = [[UILabel alloc] init];
        [gouwuquanView addSubview:gouwuquanTipLb];
        [gouwuquanTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(gouwuquanView);
            make.left.equalTo(lbFenge4);
            if (iPhone6SP) {
                make.height.equalTo(@(16));
                gouwuquanTipLb.font = [UIFont systemFontOfSize:16];
            }else if (iPhone6S) {
                make.height.equalTo(@(15));
                gouwuquanTipLb.font = [UIFont systemFontOfSize:15];
            }else {
                make.height.equalTo(@(14));
                gouwuquanTipLb.font = [UIFont systemFontOfSize:14];
            }
        }];
        gouwuquanTipLb.textColor = FUIColorFromRGB(0x4e4e4e);
        gouwuquanTipLb.text = @"购物券";
        
        // 选择购物券按钮
        _gouwuquanBtn = [[UIButton alloc] init];
        [gouwuquanView addSubview:_gouwuquanBtn];
        [_gouwuquanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(gouwuquanView);
            make.right.equalTo(self).with.offset(- Width * 0.03125);
            make.height.equalTo(gouwuquanView);
        }];
        _gouwuquanBtn.imageView.sd_layout
        .centerYEqualToView(_gouwuquanBtn)
        .rightEqualToView(_gouwuquanBtn)
        .widthIs(7.42857)
        .heightIs(13);
        if (iPhone6SP) {
            _gouwuquanBtn.titleLabel.sd_layout
            .rightSpaceToView(_gouwuquanBtn.imageView,6)
            .centerYEqualToView(_gouwuquanBtn)
            .heightIs(15)
            .widthIs(200);
            _gouwuquanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        }else if (iPhone6S) {
            _gouwuquanBtn.titleLabel.sd_layout
            .rightSpaceToView(_gouwuquanBtn.imageView,5)
            .centerYEqualToView(_gouwuquanBtn)
            .heightIs(14)
            .widthIs(200);
            _gouwuquanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }else {
            _gouwuquanBtn.titleLabel.sd_layout
            .rightSpaceToView(_gouwuquanBtn.imageView,4)
            .centerYEqualToView(_gouwuquanBtn)
            .heightIs(13)
            .widthIs(200);
            _gouwuquanBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        [_gouwuquanBtn setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_gouwuquanBtn setImage:[UIImage imageNamed:@"account_forward"] forState:UIControlStateNormal];
        _gouwuquanBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        
        
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(gouwuquanView.mas_bottom);
            make.right.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(BuyNumViewHeight));
        }];
        _endPriceLb = [[UILabel alloc] init];
        [view addSubview:_endPriceLb];
        [_endPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(self).with.offset(- Width * 0.03125);
            make.height.equalTo(@(15));
        }];
        _endPriceLb.font = [UIFont systemFontOfSize:15];
        _endPriceLb.textColor = FUIColorFromRGB(0x8979ff);

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
