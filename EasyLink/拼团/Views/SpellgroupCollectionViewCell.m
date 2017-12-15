//
//  SpellgroupCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 17/2/8.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "SpellgroupCollectionViewCell.h"

@implementation SpellgroupCollectionViewCell

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 商品图片的高
        CGFloat goodsHeigeht = 0.615 * self.frame.size.height;
        
        // 商品图片
        self.goodsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, goodsHeigeht)];
        [self addSubview:self.goodsImgView];
        
        // 标题label
        self.titleLb = [[UILabel alloc] init];
        [self addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsImgView.mas_bottom).with.offset(0.05 * self.frame.size.height);
            make.left.equalTo(self).with.offset(0.03125 * self.frame.size.width);
            make.right.equalTo(self).with.offset(- 0.03125 * self.frame.size.width);
            if (iPhone6SP) {
                make.height.equalTo(@(16));
            }else if (iPhone6S) {
                make.height.equalTo(@(15));
            }else {
                make.height.equalTo(@(14));
            }
            
        }];
        self.titleLb.textColor = FUIColorFromRGB(0x212121);
        if (iPhone6SP) {
            self.titleLb.font = [UIFont systemFontOfSize:16];
        }else if (iPhone6S) {
            self.titleLb.font = [UIFont systemFontOfSize:15];
        }else {
            self.titleLb.font = [UIFont systemFontOfSize:14];
        }
        
    
        // 拼团图片
        self.pinImgView = [[UIImageView alloc] init];
        [self addSubview:self.pinImgView];
        [self.pinImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhone6SP) {
                make.top.equalTo(self.titleLb.mas_bottom).with.offset(((1 - 0.05)* self.frame.size.height - goodsHeigeht - 16 - 0.2*self.frame.size.height) / 2);
            }else if (iPhone6S) {
                make.top.equalTo(self.titleLb.mas_bottom).with.offset(((1 - 0.05)* self.frame.size.height - goodsHeigeht - 15 - 0.2*self.frame.size.height) / 2);
            }else {
                make.top.equalTo(self.titleLb.mas_bottom).with.offset(((1 - 0.05)* self.frame.size.height - goodsHeigeht - 14 - 0.2*self.frame.size.height) / 2);
            }
            make.right.equalTo(self).with.offset(- 0.095 * self.frame.size.width);
            make.height.equalTo(@(0.2 * self.frame.size.height));
            make.width.equalTo(@(0.2 * self.frame.size.height));
        }];
        self.pinImgView.layer.cornerRadius = 0.1 * self.frame.size.height;
        self.pinImgView.clipsToBounds = YES;
        self.pinImgView.backgroundColor = FUIColorFromRGB(0x8979ff);
        // 拼字图片
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.pinImgView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.pinImgView);
            make.centerY.equalTo(self.pinImgView);
            make.width.equalTo(self.pinImgView).multipliedBy(0.4);
            make.height.equalTo(self.pinImgView).multipliedBy(0.4);
        }];
        imgView.image = [UIImage imageNamed:@"home_button2"];
        
        
        // 右侧小图
        self.rightImgView = [[UIImageView alloc] init];
        [self addSubview:self.rightImgView];
        [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pinImgView.mas_right).with.offset(self.frame.size.width * 0.0125);
            make.centerY.equalTo(self.pinImgView);
            make.width.equalTo(@(0.015625 * self.frame.size.width));
            make.height.equalTo(@(0.015625 * self.frame.size.width * 2.375));
        }];
        self.rightImgView.image = [UIImage imageNamed:@"home_button3"];
        
        // 进度条灰色背景
        self.progressBGLabel = [[UILabel alloc] init];
        [self addSubview:self.progressBGLabel];
        [self.progressBGLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.pinImgView);
            make.left.equalTo(self.titleLb);
            make.right.equalTo(self.pinImgView.mas_left).with.offset(- 0.03125 * self.frame.size.width);
            if (iPhone6SP) {
                make.height.equalTo(@(12));
            }else if (iPhone6S) {
                make.height.equalTo(@(11));
            }else {
                make.height.equalTo(@(10));
            }
        }];
        self.progressBGLabel.backgroundColor = FUIColorFromRGB(0xe9e9e9);
        if (iPhone6SP) {
            self.progressBGLabel.layer.cornerRadius = 6;
        }else if (iPhone6S) {
            self.progressBGLabel.layer.cornerRadius = 5.5;
        }else {
            self.progressBGLabel.layer.cornerRadius = 5;
        }
        self.progressBGLabel.clipsToBounds = YES;
        
        
        // 进度条图片
        self.progressImgView = [[UIImageView alloc] init];
        if (iPhone6SP) {
            self.progressImgView.frame = CGRectMake(0, 0, 0, 12);
        }else if (iPhone6S) {
            self.progressImgView.frame = CGRectMake(0, 0, 0, 11);
        }else {
            self.progressImgView.frame = CGRectMake(0, 0, 0, 10);
        }
        [self.progressBGLabel addSubview:self.progressImgView];
        
        
        // 当前人数label
        self.currentNumLb = [[UILabel alloc] init];
        [self.progressImgView addSubview:self.currentNumLb];
        [self.currentNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.progressImgView);
            make.right.equalTo(self.progressImgView);
            if (iPhone6SP) {
                make.height.equalTo(@(12));
            }else if (iPhone6S) {
                make.height.equalTo(@(11));
            }else {
                make.height.equalTo(@(10));
            }
            
        }];
        if (iPhone6SP) {
            self.currentNumLb.font = [UIFont systemFontOfSize:12];
        }else if (iPhone6S) {
            self.currentNumLb.font = [UIFont systemFontOfSize:11];
        }else {
            self.currentNumLb.font = [UIFont systemFontOfSize:10];
        }
        self.currentNumLb.textColor = FUIColorFromRGB(0xffffff);
        
        // 成团人数
        self.maxAndPriceLb = [[UILabel alloc] init];
        [self addSubview:self.maxAndPriceLb];
        [self.maxAndPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhone6SP) {
                make.top.equalTo(self.progressBGLabel.mas_bottom).with.offset(4);
            }else if (iPhone6S) {
                make.top.equalTo(self.progressBGLabel.mas_bottom).with.offset(3);
            }else {
                make.top.equalTo(self.progressBGLabel.mas_bottom).with.offset(2);
            }
            make.right.equalTo(self.progressBGLabel);
            if (iPhone6SP) {
                make.height.equalTo(@(12));
            }else if (iPhone6S) {
                make.height.equalTo(@(11));
            }else {
                make.height.equalTo(@(10));
            }
        }];
        self.maxAndPriceLb.textColor = FUIColorFromRGB(0x999999);
        if (iPhone6SP) {
            self.maxAndPriceLb.font = [UIFont systemFontOfSize:12];
        }else if (iPhone6S) {
            self.maxAndPriceLb.font = [UIFont systemFontOfSize:11];
        }else {
            self.maxAndPriceLb.font = [UIFont systemFontOfSize:10];
        }
        
        
        // 多小人图片（不用动）
        self.smallMorePersonImageView = [[UIImageView alloc] init];
        [self addSubview:_smallMorePersonImageView];
        [_smallMorePersonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.maxAndPriceLb);
            if (iPhone6SP) {
                make.right.equalTo(self.maxAndPriceLb.mas_left).with.offset(-4);
                make.height.equalTo(@(12));
                make.width.equalTo(@(12 * 1.3846));
            }else if (iPhone6S) {
                make.right.equalTo(self.maxAndPriceLb.mas_left).with.offset(-3);
                make.height.equalTo(@(11));
                make.width.equalTo(@(11 * 1.3846));
            }else {
                make.right.equalTo(self.maxAndPriceLb.mas_left).with.offset(-2);
                make.height.equalTo(@(10));
                make.width.equalTo(@(10 * 1.3846));
            }
        }];
        self.smallMorePersonImageView.image = [UIImage imageNamed:@"home_user2"];
        
        // 小人图片（不用动）
        self.smallPersonImageView = [[UIImageView alloc] init];
        [self addSubview:_smallPersonImageView];
        [_smallPersonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.maxAndPriceLb);
            make.left.equalTo(self.progressBGLabel);
            if (iPhone6SP) {
                make.height.equalTo(@(12));
                make.width.equalTo(@(12));
            }else if (iPhone6S) {
                make.height.equalTo(@(11));
                make.width.equalTo(@(11));
            }else {
                make.height.equalTo(@(10));
                make.width.equalTo(@(10));
            }
        }];
        _smallPersonImageView.image = [UIImage imageNamed:@"home_user1"];
        
        // 0人label（不用动）
        self.zeroPersonLb = [[UILabel alloc] init];
        [self addSubview:self.zeroPersonLb];
        [self.zeroPersonLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_smallPersonImageView);
            if (iPhone6SP) {
                make.left.equalTo(_smallPersonImageView.mas_right).with.offset(4);
                make.height.equalTo(@(12));
                self.zeroPersonLb.font = [UIFont systemFontOfSize:12];
            }else if (iPhone6S) {
                make.left.equalTo(_smallPersonImageView.mas_right).with.offset(3);
                make.height.equalTo(@(11));
                self.zeroPersonLb.font = [UIFont systemFontOfSize:11];
            }else {
                make.left.equalTo(_smallPersonImageView.mas_right).with.offset(2);
                make.height.equalTo(@(10));
                self.zeroPersonLb.font = [UIFont systemFontOfSize:10];
            }
        }];
        self.zeroPersonLb.textColor = FUIColorFromRGB(0x999999);
        self.zeroPersonLb.text = @"0";

        
        // 成团价格
        self.priceLb = [[UILabel alloc] init];
        [self addSubview:self.priceLb];
        [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhone6SP) {
                make.bottom.equalTo(self.progressBGLabel.mas_top).with.offset(- 6);
                make.height.equalTo(@(13));
                self.priceLb.font = [UIFont systemFontOfSize:13];
            }else if (iPhone6S) {
                make.bottom.equalTo(self.progressBGLabel.mas_top).with.offset(- 5);
                make.height.equalTo(@(12));
                self.priceLb.font = [UIFont systemFontOfSize:12];
            }else {
                make.bottom.equalTo(self.progressBGLabel.mas_top).with.offset(- 4);
                make.height.equalTo(@(11));
                self.priceLb.font = [UIFont systemFontOfSize:11];
            }
            make.left.equalTo(self.titleLb);
        }];
        self.priceLb.textColor = FUIColorFromRGB(0xfe5f79);
        
        
        // 倒计时label
        self.countDownLabel = [[UILabel alloc] init];
        [self addSubview:self.countDownLabel];
        [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.priceLb);
            make.right.equalTo(self.pinImgView.mas_left).with.offset(- 0.03125 * self.frame.size.width);
            if (iPhone6SP) {
                make.height.equalTo(@(13));
            }else if (iPhone6S) {
                make.height.equalTo(@(12));
            }else {
                make.height.equalTo(@(11));
            }
        }];
        self.countDownLabel.font = [UIFont systemFontOfSize:13];
        
        
        // 显示“活动倒计时”的Label
        self.daojishiLabel = [[UILabel alloc] init];
        [self addSubview:self.daojishiLabel];
        [self.daojishiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.priceLb);
            if (iPhone6SP) {
                make.height.equalTo(@(13));
                self.daojishiLabel.font = [UIFont systemFontOfSize:13];
                make.right.equalTo(self.countDownLabel).with.offset(-83);
            }else if (iPhone6S) {
                make.height.equalTo(@(12));
                self.daojishiLabel.font = [UIFont systemFontOfSize:12];
                make.right.equalTo(self.countDownLabel).with.offset(-77);
            }else {
                make.height.equalTo(@(11));
                self.daojishiLabel.font = [UIFont systemFontOfSize:11];
                make.right.equalTo(self.countDownLabel).with.offset(-71);
            }
        }];
        self.daojishiLabel.text = @"活动倒计时";
        self.daojishiLabel.textColor = FUIColorFromRGB(0x999999);
    }
    
    return self;
}


@end
