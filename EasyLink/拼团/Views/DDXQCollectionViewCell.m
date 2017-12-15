//
//  DDXQCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/10.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "DDXQCollectionViewCell.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation DDXQCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    self =  [super initWithFrame:frame];
    
    if (self) {
        
        // 标题
        _titleLb = [[UILabel alloc] init];
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(Width / 32);
            make.height.equalTo(self);
        }];
        if (iPhone6SP) {
            _titleLb.font = [UIFont systemFontOfSize:16];
        }else if (iPhone6S) {
            _titleLb.font = [UIFont systemFontOfSize:15];
        }else {
            _titleLb.font = [UIFont systemFontOfSize:14];
        }
        _titleLb.textColor = FUIColorFromRGB(0x999999);
        
        // 信息label
        _infoLb = [[UILabel alloc] init];
        [self addSubview:_infoLb];
        [_infoLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(- Width /32);
            make.height.equalTo(self);
        }];
        if (iPhone6SP) {
            _infoLb.font = [UIFont systemFontOfSize:16];
        }else if (iPhone6S) {
            _infoLb.font = [UIFont systemFontOfSize:15];
        }else {
            _infoLb.font = [UIFont systemFontOfSize:14];
        }
        _infoLb.textColor = FUIColorFromRGB(0x999999);

    }
    
    return self;
}

@end
