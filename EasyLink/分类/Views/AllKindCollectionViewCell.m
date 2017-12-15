//
//  AllKindCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/17.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "AllKindCollectionViewCell.h"

@implementation AllKindCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

// 创建frame
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 图片宽高比 1:0.3625
        self.KindImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.3625 * self.frame.size.width)];
        [self addSubview:self.KindImgView];
        
        // 遮罩层
        self.zheZhaoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.3625 * self.frame.size.width)];
        self.zheZhaoImgView.backgroundColor = [UIColor blackColor];
        self.zheZhaoImgView.alpha = 0.2;
        [self.KindImgView addSubview:self.zheZhaoImgView];
        
        // 种类按钮
        self.btnKind = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0.21875* self.frame.size.width, 0.0352 * [UIScreen mainScreen].bounds.size.height)];
        CGPoint pt = _KindImgView.center;
        pt.y -= 5;
        self.btnKind.center = pt;
        [self addSubview:self.btnKind];
        self.btnKind.layer.cornerRadius = 0.0352 * [UIScreen mainScreen].bounds.size.height / 2;
        self.btnKind.layer.borderColor = FUIColorFromRGB(0xffffff).CGColor;
        self.btnKind.layer.borderWidth = 1.0;
        self.btnKind.clipsToBounds = YES;
        [self.btnKind setTitleColor:FUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        self.btnKind.titleLabel.font = [UIFont systemFontOfSize:13];
        
        
        // 简单介绍
        self.titleLb = [[UILabel alloc] init];
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_btnKind.mas_bottom).with.offset(0.078261 * self.frame.size.height);
            make.centerX.equalTo(_KindImgView);
            make.height.equalTo(@(12));
        }];
        self.titleLb.textColor = FUIColorFromRGB(0xffffff);
        self.titleLb.font = [UIFont systemFontOfSize:11];
        
        
        // 种类视图
        self.btnKindUv = [[UIView alloc] initWithFrame:CGRectMake(0, self.KindImgView.frame.size.height, self.frame.size.width, 0)];
        [self addSubview:self.btnKindUv];
    }
    
    return self;
}

@end
