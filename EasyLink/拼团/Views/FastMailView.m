//
//  FastMailView.m
//  EasyLink
//
//  Created by 琦琦 on 2017/5/21.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "FastMailView.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation FastMailView

// 
- (id)initWithFrame:(CGRect)frame {
    
    self =  [super initWithFrame:frame];
    
    if (self) {
        
        // 已选
        UILabel *peisongxinxiLb = [[UILabel alloc] init];
        [self addSubview:peisongxinxiLb];
        [peisongxinxiLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(WIDTH * 0.03125);
            if (iPhone6SP) {
                make.height.equalTo(@(14));
                peisongxinxiLb.font = [UIFont systemFontOfSize:14];
            }else if (iPhone6S) {
                make.height.equalTo(@(13));
                peisongxinxiLb.font = [UIFont systemFontOfSize:13];
            }else {
                make.height.equalTo(@(12));
                peisongxinxiLb.font = [UIFont systemFontOfSize:12];
            }
        }];
        peisongxinxiLb.textColor = FUIColorFromRGB(0x999999);
        peisongxinxiLb.text = @"配送信息";
        
        
        
        // 选取规格按钮
        _lookPeisongDetailBtn = [[UIButton alloc] init];
        [self addSubview:_lookPeisongDetailBtn];
        [_lookPeisongDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(peisongxinxiLb.mas_right).with.offset(WIDTH*0.03125);
            make.height.equalTo(self);
            make.width.equalTo(@(WIDTH - WIDTH*0.03125*4 - peisongxinxiLb.width - 7.5));
        }];
        
        // 按钮文字
        _lookPeisongDetailBtn.titleLabel.sd_layout
        .centerYEqualToView(_lookPeisongDetailBtn)
        .leftEqualToView(_lookPeisongDetailBtn)
        .rightEqualToView(_lookPeisongDetailBtn);
        if (iPhone6SP) {
            _lookPeisongDetailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }else if (iPhone6S) {
            _lookPeisongDetailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        }else {
            _lookPeisongDetailBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        }
        [_lookPeisongDetailBtn setTitleColor:FUIColorFromRGB(0x212121) forState:UIControlStateNormal];
        // 右侧大于号图标
        UIImageView *rightImgView2 = [[UIImageView alloc] init];
        [self addSubview:rightImgView2];
        [rightImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(- WIDTH * 0.03125);
            make.centerY.equalTo(self);
            make.width.equalTo(@(7.42857));
            make.height.equalTo(@(13));
        }];
        rightImgView2.image = [UIImage imageNamed:@"account_forward"];
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
