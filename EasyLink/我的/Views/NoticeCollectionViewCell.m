//
//  NoticeCollectionViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 16/11/23.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "NoticeCollectionViewCell.h"

@implementation NoticeCollectionViewCell

- (id) initWithFrame:(CGRect)frame {
    
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
        
        // 未读Lb
        self.lbWeiDu = [[UILabel alloc] init];
        [self.cellMainView addSubview:_lbWeiDu];
        [_lbWeiDu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLb);
            make.left.equalTo(self.detailLb);
            make.height.equalTo(@(10));
            make.width.equalTo(@(10));
        }];
        self.lbWeiDu.backgroundColor = FUIColorFromRGB(0xfe5f5f);
        self.lbWeiDu.layer.cornerRadius = 5;
        self.lbWeiDu.clipsToBounds = YES;
        self.lbWeiDu.hidden = YES;
        
        self.btnRight = [[UIButton alloc] init];
        [self.cellMainView addSubview:self.btnRight];
        [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLb);
            make.right.equalTo(self.detailLb);
            make.height.equalTo(self.titleLb);
        }];
        self.btnRight.imageView.sd_layout
        .topSpaceToView(self.btnRight,0)
        .rightSpaceToView(self.btnRight,0)
        .heightIs(15)
        .widthIs(8.5714);
        self.btnRight.titleLabel.sd_layout
        .topSpaceToView(self.btnRight,1.5)
        .rightSpaceToView(self.btnRight.imageView, - 2)
        .heightIs(12)
        .widthIs(60);
        
        [self.btnRight setTitle:@"16-10-29" forState:UIControlStateNormal];
        [self.btnRight setImage:[UIImage imageNamed:@"绑定银行卡_点击选择"] forState:UIControlStateNormal];
        [self.btnRight setTitleColor:FUIColorFromRGB(0x999999) forState:UIControlStateNormal];
        self.btnRight.titleLabel.font = [UIFont systemFontOfSize:12];
        
        
        // 选择视图
        self.selectUv = [[UIView alloc] initWithFrame:CGRectMake(- (0.03125 * self.frame.size.width + 15), 0, 0.03125 * self.frame.size.width + 15, self.frame.size.height)];
        [self addSubview:self.selectUv];
        self.selectUv.backgroundColor = FUIColorFromRGB(0xffffff);
        
        self.selectBtn = [[UIButton alloc] init];
        [self.selectUv addSubview:self.selectBtn];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectUv);
            make.right.equalTo(self.selectUv);
            make.width.equalTo(self.selectUv);
            make.height.equalTo(self.selectUv);
        }];
        self.selectBtn.imageView.sd_layout
        .rightSpaceToView(self.selectBtn,0)
        .centerYEqualToView(self.selectBtn)
        .widthIs(15)
        .heightIs(15);
        [self.selectBtn setImage:[UIImage imageNamed:@"品类列表_详情_答题off"] forState:UIControlStateNormal];
        self.selectBtn.selected = NO;
        
    }
    
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    self.selectBtn.selected = NO;
    [self.selectBtn setImage:[UIImage imageNamed:@"品类列表_详情_答题off"] forState:UIControlStateNormal];
    
    self.lbWeiDu.hidden = YES;
    
    self.titleLb.frame = CGRectMake(0.03125 * self.frame.size.width, 0.2069 * self.cellMainView.frame.size.height, 0.75 * self.frame.size.width - 5, 0.15 * self.frame.size.height);
}


@end
