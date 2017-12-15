//
//  EvaluateCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/1.
//  Copyright © 2017年 fengdian. All rights reserved.
//  评价

#import "EvaluateCollectionViewCell.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation EvaluateCollectionViewCell

// 创建frame
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 150
        
        
        // 头像
        _touxiangImgView = [[UIImageView alloc] init];
        [self addSubview:_touxiangImgView];
        [_touxiangImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(Width * 0.03125);
            make.left.equalTo(self).with.offset(Width * 0.03125);
            make.height.equalTo(@(Width * 0.103125));
            make.width.equalTo(@(Width * 0.103125));
        }];
        _touxiangImgView.layer.cornerRadius = Width * 0.103125 / 2;
        _touxiangImgView.clipsToBounds = YES;
        
        // 昵称
        _nicknameLb = [[UILabel alloc] init];
        [self addSubview:_nicknameLb];
        [_nicknameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(0.046875 * Width);
            make.left.equalTo(_touxiangImgView.mas_right).with.offset(Width * 0.0203125);
            if (iPhone6SP) {
                make.height.equalTo(@(15));
                _nicknameLb.font = [UIFont systemFontOfSize:15];
            }else if (iPhone6S) {
                make.height.equalTo(@(14));
                _nicknameLb.font = [UIFont systemFontOfSize:14];
            }else {
                make.height.equalTo(@(13));
                _nicknameLb.font = [UIFont systemFontOfSize:13];
            }
        }];
        _nicknameLb.textColor = FUIColorFromRGB(0x212121);
        
        // 日期
        _dateLb = [[UILabel alloc] init];
        [self addSubview:_dateLb];
        [_dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(- Width * 0.03125);
            make.bottom.equalTo(_nicknameLb);
            if (iPhone6SP) {
                make.height.equalTo(@(13));
                _dateLb.font = [UIFont systemFontOfSize:13];
            }else if (iPhone6S) {
                make.height.equalTo(@(12));
                _dateLb.font = [UIFont systemFontOfSize:12];
            }else {
                make.height.equalTo(@(11));
                _dateLb.font = [UIFont systemFontOfSize:11];
            }
        }];
        _dateLb.textColor = FUIColorFromRGB(0x999999);
        
        // 评价
        _pingjiaLb = [[UILabel alloc] init];
        [self addSubview:_pingjiaLb];
        [_pingjiaLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nicknameLb.mas_bottom).with.offset(0.034375 * Width);
            make.left.equalTo(_nicknameLb);
            make.right.equalTo(_dateLb);
        }];
        _pingjiaLb.textColor = FUIColorFromRGB(0x999999);
        _pingjiaLb.font = [UIFont systemFontOfSize:12];
        
        // 星级视图
        _bar = [[RatingBar alloc] initWithFrame:CGRectMake(0, 0, 12 * 7, 12)];
        [self addSubview:_bar];
        [_bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_nicknameLb);
            make.width.equalTo(@(84));
            make.height.equalTo(@(12));
            make.left.equalTo(_nicknameLb.mas_right);
        }];
        
    }
    
    return self;
}

@end
