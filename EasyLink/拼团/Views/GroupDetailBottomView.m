//
//  GroupDetailBottomView.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/7.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "GroupDetailBottomView.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation GroupDetailBottomView

// 重写init方法
- (id)initWithFrame:(CGRect)frame andType:(NSInteger) type {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 背景色加透明度
        self.backgroundColor = [FUIColorFromRGB(0xf8f8f8) colorWithAlphaComponent:0.9];
        
        // 关注btn
        _guanzhuBtn = [[UIButton alloc] init];
        [self addSubview:_guanzhuBtn];
        [_guanzhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.height.equalTo(@(49));
            make.left.equalTo(self);
        }];
        _guanzhuBtn.imageView.sd_layout
        .leftSpaceToView(_guanzhuBtn,Width*0.040625)
        .centerYEqualToView(_guanzhuBtn)
        .widthIs(20)
        .heightIs(17.6);
        _guanzhuBtn.titleLabel.sd_layout
        .leftSpaceToView(_guanzhuBtn.imageView,3)
        .centerYEqualToView(_guanzhuBtn)
        .heightIs(22)
        .widthIs(62);
        _guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_guanzhuBtn setTitleColor:FUIColorFromRGB(0xfe5f79) forState:UIControlStateNormal];
        [_guanzhuBtn setImage:[UIImage imageNamed:@"发现_详情_关注off"] forState:UIControlStateNormal];
        [_guanzhuBtn setImage:[UIImage imageNamed:@"发现_详情_关注on"] forState:UIControlStateSelected];
        [_guanzhuBtn setTitle:@"添加关注" forState:UIControlStateNormal];
        [_guanzhuBtn setTitle:@"取消关注" forState:UIControlStateSelected];
        
        
        // 小拼购
        _xiaopinBtn = [[UIButton alloc] init];
        [self addSubview:_xiaopinBtn];
        [_xiaopinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(- Width * 0.03125);
            make.width.equalTo(@(Width * 0.265625));
            make.height.equalTo(@(34));
        }];
        _xiaopinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _xiaopinBtn.layer.cornerRadius = 17;
        [_xiaopinBtn setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_xiaopinBtn setTitle:@"小拼购" forState:UIControlStateNormal];
        // 判断状态
        if (type == 1) {
            _xiaopinBtn.backgroundColor = FUIColorFromRGB(0x8979ff);
        }else {
            _xiaopinBtn.backgroundColor = [UIColor colorWithRed:151/255.0 green:152/255.0 blue:153/255.0 alpha:1.0];
            _xiaopinBtn.userInteractionEnabled = NO;
        }
        
        
        // 小拼购
        _quanpinBtn = [[UIButton alloc] init];
        [self addSubview:_quanpinBtn];
        [_quanpinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(_xiaopinBtn.mas_left).with.offset(- Width * 0.03125);
            make.width.equalTo(@(Width * 0.265625));
            make.height.equalTo(@(34));
        }];
        _quanpinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _quanpinBtn.layer.cornerRadius = 17;
        [_quanpinBtn setTitle:@"全拼购" forState:UIControlStateNormal];
        _quanpinBtn.layer.borderWidth = 1.0;
        
        // 判断状态
        if (type == 1) {
            _quanpinBtn.layer.borderColor = FUIColorFromRGB(0x8979ff).CGColor;
            [_quanpinBtn setTitleColor:FUIColorFromRGB(0x8979ff) forState:UIControlStateNormal];
        }else {
            _quanpinBtn.layer.borderColor = [UIColor colorWithRed:151/255.0 green:152/255.0 blue:153/255.0 alpha:1.0].CGColor;
            [_quanpinBtn setTitleColor:[UIColor colorWithRed:151/255.0 green:152/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
            _quanpinBtn.userInteractionEnabled = NO;
        }
        
        
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
