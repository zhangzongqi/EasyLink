//
//  DingDanBianhaoAndStatus.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/9.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "DingDanBianhaoAndStatus.h"

#define Width self.frame.size.width
#define Height self.frame.size.height


@implementation DingDanBianhaoAndStatus


- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 顶部提示语
        self.backgroundColor = FUIColorFromRGB(0xffffff);
        
        _dingDanNumLb = [[UILabel alloc] init];
        [self addSubview:_dingDanNumLb];
        [_dingDanNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(Width * 0.03125);
        }];
        _dingDanNumLb.textColor = FUIColorFromRGB(0x212121);
        if (iPhone6SP) {
            _dingDanNumLb.font = [UIFont systemFontOfSize:15];
        }else if (iPhone6S) {
            _dingDanNumLb.font = [UIFont systemFontOfSize:14];
        }else {
            _dingDanNumLb.font = [UIFont systemFontOfSize:13];
        }

        _dingdanStatusLb = [[UILabel alloc] init];
        [self addSubview:_dingdanStatusLb];
        [_dingdanStatusLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(- Width * 0.03125);
        }];
        _dingdanStatusLb.textColor = FUIColorFromRGB(0x8979ff);
        if (iPhone6SP) {
            _dingdanStatusLb.font = [UIFont systemFontOfSize:15];
        }else if (iPhone6S) {
            _dingdanStatusLb.font = [UIFont systemFontOfSize:14];
        }else {
            _dingdanStatusLb.font = [UIFont systemFontOfSize:13];
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
