//
//  AdressTableViewCell.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/7.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "AdressTableViewCell.h"

@implementation AdressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        // 姓名Label
        self.nameLb = [[UILabel alloc] init];
        [self addSubview:self.nameLb];
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self).with.offset(25);
            make.left.equalTo(self).with.offset(18);
            make.height.equalTo(@(20));
        }];
        self.nameLb.textColor = FUIColorFromRGB(0x212121);
        self.nameLb.font = [UIFont systemFontOfSize:15];
        
        // 电话Label
        self.phoneLb = [[UILabel alloc] init];
        [self addSubview:self.phoneLb];
        self.phoneLb.textColor = FUIColorFromRGB(0x212121);
        self.phoneLb.font = [UIFont systemFontOfSize:15];
        [self.phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.nameLb);
            make.left.equalTo(self.nameLb.mas_right).with.offset(16);
        }];
        
        
        // 地址Label
        self.addressLb = [[UILabel alloc] init];
        [self addSubview:self.addressLb];
        [self.addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(-25);
            make.left.equalTo(self.nameLb);
        }];
        self.addressLb.font = [UIFont systemFontOfSize:14];
        self.addressLb.textColor = FUIColorFromRGB(0x999999);
        
        // 修改按钮
        self.reviseBtn = [[UIButton alloc] init];
        [self addSubview:self.reviseBtn];
        [self.reviseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@(50));
            make.width.equalTo(@(60));
        }];
        self.reviseBtn.imageView.sd_layout
        .centerXEqualToView(self.reviseBtn)
        .centerYEqualToView(self.reviseBtn)
        .widthIs(25)
        .heightIs(25);
        // 设置图片
        [self.reviseBtn setImage:[UIImage imageNamed:@"address_icon1"] forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
