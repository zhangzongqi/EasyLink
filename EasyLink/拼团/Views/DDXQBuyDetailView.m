//
//  DDXQBuyDetailView.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/9.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "DDXQBuyDetailView.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation DDXQBuyDetailView

- (id) initWithFrame:(CGRect)frame {
    //    640*413
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = FUIColorFromRGB(0xffffff);
        
        CGFloat topViewHeight = Height * 0.41404358353511;
        
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
        
        
        
        CGFloat peisongViewHeight = Height * 0.1961259;
        
        // 配送信息View
        UIView *peisongView = [[UIView alloc] init];
        [self addSubview: peisongView];
        [peisongView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(peisongViewHeight));
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
        [peisongView addSubview:peisongTipLb];
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
        _peiSongLabel = [[UILabel alloc] init];
        [self addSubview:_peiSongLabel];
        [_peiSongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(peisongView);
            make.right.equalTo(self).with.offset(- Width * 0.03125);
            make.height.equalTo(peisongView);
        }];
        if (iPhone6SP) {
            _peiSongLabel.font = [UIFont systemFontOfSize:15];
        }else if (iPhone6S) {
            _peiSongLabel.font = [UIFont systemFontOfSize:14];
        }else {
            _peiSongLabel.font = [UIFont systemFontOfSize:13];
        }
        _peiSongLabel.textColor = FUIColorFromRGB(0x999999);

        
        
        // 购物券view
        UIView *gouwuquanView = [[UIView alloc] init];
        [self addSubview:gouwuquanView];
        [gouwuquanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(peisongView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(peisongViewHeight));
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
        
        // 购物券
        _gouwuquanLabel = [[UILabel alloc] init];
        [gouwuquanView addSubview:_gouwuquanLabel];
        [_gouwuquanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(gouwuquanView);
            make.right.equalTo(self).with.offset(- Width * 0.03125);
            make.height.equalTo(gouwuquanView);
        }];
        if (iPhone6SP) {
            _gouwuquanLabel.font = [UIFont systemFontOfSize:15];
        }else if (iPhone6S) {
            _gouwuquanLabel.font = [UIFont systemFontOfSize:14];
        }else {
            _gouwuquanLabel.font = [UIFont systemFontOfSize:13];
        }
        _gouwuquanLabel.textColor = FUIColorFromRGB(0x999999);
        
        
        
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(gouwuquanView.mas_bottom);
            make.right.equalTo(self);
            make.width.equalTo(@(Width));
            make.height.equalTo(@(peisongViewHeight));
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
