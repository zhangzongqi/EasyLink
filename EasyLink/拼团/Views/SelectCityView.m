//
//  SelectCityView.m
//  EasyLink
//
//  Created by 琦琦 on 17/3/1.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "SelectCityView.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation SelectCityView

// 创建frame
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = FUIColorFromRGB(0xffffff);
        
        // 顶部视图
        UIView *TopView = [[UIView alloc] init];
        [self addSubview:TopView];
        [TopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(@(48));
        }];
        
        // 关闭按钮
        _closeBtn = [[UIButton alloc] init];
        [TopView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(TopView);
            make.left.equalTo(self).with.offset(0.04 * Width);
            make.height.equalTo(@(48));
            make.width.equalTo(@(48));
        }];
        _closeBtn.imageView.sd_layout
        .centerYEqualToView(_closeBtn)
        .leftSpaceToView(_closeBtn,0)
        .widthRatioToView(_closeBtn,0.333)
        .heightRatioToView(_closeBtn,0.333);
        [_closeBtn setImage:[UIImage imageNamed:@"home_close"] forState:UIControlStateNormal];
        
        // 提示选择城市
        _tipSelect = [[UILabel alloc] init];
        [TopView addSubview:_tipSelect];
        [_tipSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(TopView);
            make.centerX.equalTo(TopView);
            make.height.equalTo(@(16));
        }];
        _tipSelect.font = [UIFont systemFontOfSize:16];
        _tipSelect.textColor = FUIColorFromRGB(0x212121);
        _tipSelect.text = @"选择城市";
        
        // 分隔线
        UILabel *lbFenge = [[UILabel alloc] init];
        [self addSubview:lbFenge];
        [lbFenge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(TopView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(@(1));
        }];
        lbFenge.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
        // 城市tableview
        _citytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 49, self.frame.size.width, Height - 49) style:UITableViewStylePlain];
        [self addSubview:_citytableView];
//        [_citytableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(lbFenge.mas_bottom);
//            make.left.equalTo(self);
//            make.width.equalTo(self);
//            make.height.equalTo(@());
//        }];
        _citytableView.backgroundColor = FUIColorFromRGB(0xeeeeee);
        
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
