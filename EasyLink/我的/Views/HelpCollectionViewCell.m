//
//  HelpCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/24.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "HelpCollectionViewCell.h"

@implementation HelpCollectionViewCell

// 创建frame
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // cell主视图
        self.cellMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.cellMainView];
        self.cellMainView.backgroundColor = FUIColorFromRGB(0xffffff);
        
        // 标题label
        self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0.03125 * self.frame.size.width, 0.2069 * self.cellMainView.frame.size.height, 0.75 * self.frame.size.width - 5, 0.15 * self.frame.size.height)];
        [self.cellMainView addSubview:self.titleLb];
        self.titleLb.textColor = FUIColorFromRGB(0x212121);
        self.titleLb.font = [UIFont systemFontOfSize:15];
        
        // 内容label
        self.detailLb = [[UILabel alloc] init];
        [self.cellMainView addSubview: self.detailLb];
        [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLb.mas_bottom).with.offset(0.1111 * self.frame.size.height);
            make.left.equalTo(self.cellMainView).with.offset(0.03125 * self.frame.size.width);
            make.right.equalTo(self.cellMainView.mas_right).with.offset(- 0.03125 * self.frame.size.width);
            make.bottom.equalTo(self.cellMainView.mas_bottom).with.offset(-0.1111 * self.frame.size.height);
        }];
        self.detailLb.textColor = FUIColorFromRGB(0x999999);
        self.detailLb.font = [UIFont systemFontOfSize:12];
        self.detailLb.numberOfLines = 2;
    }
    return self;
}

@end
