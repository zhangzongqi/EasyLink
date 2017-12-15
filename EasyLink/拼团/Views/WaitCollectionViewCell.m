//
//  WaitCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 17/2/24.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "WaitCollectionViewCell.h"

@implementation WaitCollectionViewCell

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 商品图片的高
        CGFloat goodsHeigeht = 0.66 * self.frame.size.height;
        
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
        
        // 提示未开团
        self.tipWaitLb = [[UILabel alloc] init];
        [self addSubview:self.tipWaitLb];
        [self.tipWaitLb mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhone6SP) {
                make.top.equalTo(self.titleLb.mas_bottom).with.offset(((1-0.05)*self.frame.size.height - 16 - goodsHeigeht - 14) / 2);
                make.height.equalTo(@(14));
                self.tipWaitLb.font = [UIFont systemFontOfSize:14];
            }else if (iPhone6S) {
                make.top.equalTo(self.titleLb.mas_bottom).with.offset(((1-0.05)*self.frame.size.height - 15 - goodsHeigeht - 13) / 2);
                make.height.equalTo(@(13));
                self.tipWaitLb.font = [UIFont systemFontOfSize:13];
            }else {
                make.top.equalTo(self.titleLb.mas_bottom).with.offset(((1-0.05)*self.frame.size.height - 14 - goodsHeigeht - 12) / 2);
                make.height.equalTo(@(12));
                self.tipWaitLb.font = [UIFont systemFontOfSize:12];
            }
            make.left.equalTo(self.titleLb);
        }];
        self.tipWaitLb.textColor = FUIColorFromRGB(0xfe5f79);
        self.tipWaitLb.text = @"即将开团,敬请期待!";
        
        // 倒计时视图
        self.viewForTime = [[UIView alloc] init];
        [self addSubview:self.viewForTime];
        [self.viewForTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLb.mas_bottom);
            make.right.equalTo(self).with.offset(- 0.095 * self.frame.size.width);
            make.width.equalTo(@(0.25 * self.frame.size.width));
            if (iPhone6SP) {
                
                make.height.equalTo(@((1 - 0.05) * self.frame.size.height - goodsHeigeht - 16));
            }else if (iPhone6S) {
                
                make.height.equalTo(@((1 - 0.05) * self.frame.size.height - goodsHeigeht - 15));
            }else {
                
                make.height.equalTo(@((1 - 0.05) * self.frame.size.height - goodsHeigeht - 14));
            }
        }];
        self.viewForTime.backgroundColor = [UIColor whiteColor];
        
        self.waitDayLabel = [[UILabel alloc] init];
        [self.viewForTime addSubview:self.waitDayLabel];
        [self.waitDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewForTime);
            make.left.equalTo(self.viewForTime);
            make.height.equalTo(self.viewForTime);
        }];
        self.waitDayLabel.textColor = FUIColorFromRGB(0xfe5f79);
        if (iPhone6SP) {
            self.waitDayLabel.font = [UIFont systemFontOfSize:15];
        }else if (iPhone6S) {
            self.waitDayLabel.font = [UIFont systemFontOfSize:14];
        }else {
            self.waitDayLabel.font = [UIFont systemFontOfSize:13];
        }
        self.waitDayLabel.textAlignment = NSTextAlignmentCenter;
        
        // 秒
        self.lbForss = [[UILabel alloc] init];
        [self.viewForTime addSubview:self.lbForss];
        [self.lbForss mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.viewForTime);
            make.right.equalTo(self.viewForTime);
            make.width.equalTo(@(self.frame.size.height *0.136));
            make.height.equalTo(@(self.frame.size.height *0.136));
        }];
        self.lbForss.layer.cornerRadius = self.frame.size.height *0.136 / 2;
        self.lbForss.clipsToBounds = YES;
        self.lbForss.backgroundColor = FUIColorFromRGB(0xfe5f79);
        
        // 右侧小图
        self.rightImgView = [[UIImageView alloc] init];
        [self addSubview:self.rightImgView];
        [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lbForss.mas_right).with.offset(self.frame.size.width * 0.0125);
            make.centerY.equalTo(self.lbForss);
            make.width.equalTo(@(0.015625 * self.frame.size.width));
            make.height.equalTo(@(0.015625 * self.frame.size.width * 2.375));
        }];
        self.rightImgView.image = [UIImage imageNamed:@"home_button4"];
        
        // 分
        self.lbFormm = [[UILabel alloc] init];
        [self.viewForTime addSubview:self.lbFormm];
        [self.lbFormm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.viewForTime);
            make.centerX.equalTo(self.viewForTime);
            make.width.equalTo(@(self.frame.size.height *0.136));
            make.height.equalTo(@(self.frame.size.height *0.136));
        }];
        self.lbFormm.layer.cornerRadius = self.frame.size.height *0.136 / 2;
        self.lbFormm.clipsToBounds = YES;
        self.lbFormm.backgroundColor = FUIColorFromRGB(0xfe5f79);
        
        // 冒号label1
        self.maohaoLb1 = [[UILabel alloc] init];
        [self.viewForTime addSubview:self.maohaoLb1];
        [self.maohaoLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_lbForss);
            make.left.equalTo(self.lbFormm);
            make.right.equalTo(self.lbForss);
            make.height.equalTo(_lbForss);
        }];
        self.maohaoLb1.text = @":";
        self.maohaoLb1.textColor = FUIColorFromRGB(0xfe5f79);
        self.maohaoLb1.font = [UIFont systemFontOfSize:15];
        self.maohaoLb1.textAlignment = NSTextAlignmentCenter;
        
        
        // 时
        self.lbForHH = [[UILabel alloc] init];
        [self.viewForTime addSubview:self.lbForHH];
        [self.lbForHH mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.viewForTime);
            make.left.equalTo(self.viewForTime);
            make.width.equalTo(@(self.frame.size.height *0.136));
            make.height.equalTo(@(self.frame.size.height *0.136));
        }];
        self.lbForHH.layer.cornerRadius = self.frame.size.height *0.136 / 2;
        self.lbForHH.clipsToBounds = YES;
        self.lbForHH.backgroundColor = FUIColorFromRGB(0xfe5f79);
        self.lbForHH.textColor = FUIColorFromRGB(0xffffff);
        if (iPhone6SP) {
            self.lbForHH.font = [UIFont systemFontOfSize:13];
        }else if (iPhone6S) {
            self.lbForHH.font = [UIFont systemFontOfSize:12];
        }else {
            self.lbForHH.font = [UIFont systemFontOfSize:11];
        }
        self.lbForHH.textAlignment = NSTextAlignmentCenter;
        
        
        // 冒号label2
        self.maohaoLb2 = [[UILabel alloc] init];
        [self.viewForTime addSubview:self.maohaoLb2];
        [self.maohaoLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_lbForss);
            make.left.equalTo(self.lbForHH);
            make.right.equalTo(self.lbFormm);
            make.height.equalTo(_lbForss);
        }];
        self.maohaoLb2.text = @":";
        self.maohaoLb2.textColor = FUIColorFromRGB(0xfe5f79);
        self.maohaoLb2.font = [UIFont systemFontOfSize:15];
        self.maohaoLb2.textAlignment = NSTextAlignmentCenter;
        
        // 倒计时提醒Label （不用动）
        self.tipDaoJiShiLb = [[UILabel alloc] init];
        [self addSubview:self.tipDaoJiShiLb];
        [self.tipDaoJiShiLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.tipWaitLb);
            make.right.equalTo(self.viewForTime.mas_left).with.offset(- 10);
            
            if (iPhone6SP) {
                make.height.equalTo(@(14));
                self.tipDaoJiShiLb.font = [UIFont systemFontOfSize:14];
            }else if (iPhone6S) {
                make.height.equalTo(@(13));
                self.tipDaoJiShiLb.font = [UIFont systemFontOfSize:13];
            }else {
                make.height.equalTo(@(12));
                self.tipDaoJiShiLb.font = [UIFont systemFontOfSize:12];
            }
        }];
        self.tipDaoJiShiLb.text = @"开团倒计时";
        self.tipDaoJiShiLb.textColor = FUIColorFromRGB(0x999999);
        
        
    }
    
    return self;
}


@end
