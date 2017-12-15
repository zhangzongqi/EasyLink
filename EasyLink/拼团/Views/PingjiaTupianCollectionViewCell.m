//
//  PingjiaTupianCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/7.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "PingjiaTupianCollectionViewCell.h"

@implementation PingjiaTupianCollectionViewCell

// 创建frame
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _pingjiaTupianImgView = [[UIImageView alloc] init];
        [self addSubview:_pingjiaTupianImgView];
        [_pingjiaTupianImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(self);
        }];
        _pingjiaTupianImgView.layer.borderWidth = 1.0;
        _pingjiaTupianImgView.layer.borderColor = FUIColorFromRGB(0xeeeeee).CGColor;
    }

    return self;
}

@end
