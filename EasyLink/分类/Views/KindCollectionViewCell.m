//
//  KindCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/3.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "KindCollectionViewCell.h"

@implementation KindCollectionViewCell

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {

        _lbKindTitle = [[UILabel alloc] init];
        [self addSubview:_lbKindTitle];
        [_lbKindTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(self);
        }];
        _lbKindTitle.textColor = FUIColorFromRGB(0x212121);
        if (iPhone6SP) {
            _lbKindTitle.font = [UIFont systemFontOfSize:15];
        }else if (iPhone6S) {
            _lbKindTitle.font = [UIFont systemFontOfSize:14];
        }else {
            _lbKindTitle.font = [UIFont systemFontOfSize:13];
        }
        _lbKindTitle.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return self;
}

@end
