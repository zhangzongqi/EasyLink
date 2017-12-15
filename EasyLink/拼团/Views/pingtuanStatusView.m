//
//  pingtuanStatusView.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/10.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "pingtuanStatusView.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation pingtuanStatusView

- (id)initWithFrame:(CGRect)frame {
    
//    640*154
    
    self =  [super initWithFrame:frame];
    
    if (self) {
        
        // 状态lable
        _statusLb = [[UILabel alloc] init];
        [self addSubview:_statusLb];
        [_statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(- Height/2);
            make.centerX.equalTo(self);
            make.height.equalTo(@(17));
        }];
        _statusLb.textColor = FUIColorFromRGB(0xff5571);
        _statusLb.font = [UIFont systemFontOfSize:17];
        
        // 预计送达时间
        _songDaTimeLb = [[UILabel alloc] init];
        [self addSubview:_songDaTimeLb];
        [_songDaTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_statusLb.mas_bottom).with.offset(Height / 7);
            make.centerX.equalTo(self);
            make.height.equalTo(@(14));
        }];
        _songDaTimeLb.textColor = FUIColorFromRGB(0x999999);
        _songDaTimeLb.font = [UIFont systemFontOfSize:14];
        
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
